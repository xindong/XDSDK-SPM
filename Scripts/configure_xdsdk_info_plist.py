#!/usr/bin/env python3
# Auto-configure App Info.plist (CFBundleURLTypes / LSApplicationQueriesSchemes /
# Facebook keys) based on XDConfig.json (and UOPSDKConfig.json when the DouYin
# CPS package is integrated). Mirrors the runtime checks performed by
# XDGPackageChecker so the App can ship without manual plist edits.
#
# Modes:
#   --mode=patch  (default) write changes to Info.plist
#   --mode=check  exit non-zero if Info.plist would change (CI lint)
#
# Environment (Xcode-provided when run as a Build Phase):
#   XDSDK_CONFIG_PATH          explicit path to XDConfig.json (optional override)
#   XDSDK_EXTRA_CONFIG_PATHS   colon-separated extra XDConfig.json paths; their
#                              URL Type tags are namespaced as
#                              `xdsdk.<ns>.<platform>` so multiple environments
#                              can coexist in one Info.plist
#   XDSDK_UOP_CONFIG_PATH      explicit path to UOPSDKConfig.json (optional override)
#   INFOPLIST_FILE             relative or absolute path to Info.plist
#   SRCROOT                    Xcode source root
#   PRODUCT_NAME               Xcode product name
#   PRODUCT_BUNDLE_IDENTIFIER  required for the Line URL scheme
#
# Managed entries are tagged so re-runs replace cleanly:
#   - URL Type entries: CFBundleURLName starts with "xdsdk."
#   - Query schemes: tracked in sidecar key XDSDKManagedQueriesSchemes
#   - Top-level string keys (e.g. FacebookAppID): tracked in sidecar key
#     XDSDKManagedTopLevelKeys

from __future__ import annotations

import argparse
import json
import os
import plistlib
import sys
from pathlib import Path

OWNER_PREFIX = "xdsdk."
QUERY_SIDECAR_KEY = "XDSDKManagedQueriesSchemes"
TOP_LEVEL_SIDECAR_KEY = "XDSDKManagedTopLevelKeys"


def env(name, default=None):
    v = os.environ.get(name)
    return v if v else default


def find_config_path():
    explicit = env("XDSDK_CONFIG_PATH")
    if explicit:
        return Path(explicit)
    srcroot = env("SRCROOT")
    product = env("PRODUCT_NAME")
    if srcroot and product:
        candidate = Path(srcroot) / product / "XDConfig.json"
        if candidate.exists():
            return candidate
    if srcroot:
        matches = list(Path(srcroot).rglob("XDConfig.json"))
        if matches:
            return matches[0]
    return None


def find_uop_config_path():
    explicit = env("XDSDK_UOP_CONFIG_PATH")
    if explicit:
        p = Path(explicit)
        return p if p.exists() else None
    srcroot = env("SRCROOT")
    product = env("PRODUCT_NAME")
    if srcroot and product:
        candidate = Path(srcroot) / product / "UOPSDKConfig.json"
        if candidate.exists():
            return candidate
    if srcroot:
        matches = list(Path(srcroot).rglob("UOPSDKConfig.json"))
        if matches:
            return matches[0]
    return None


def find_infoplist_path():
    plist = env("INFOPLIST_FILE")
    if not plist:
        return None
    p = Path(plist)
    if not p.is_absolute():
        srcroot = env("SRCROOT")
        if srcroot:
            p = Path(srcroot) / p
    return p


def is_cn(config):
    return (config.get("region_type") or "").lower() != "global"


def non_empty(value):
    return isinstance(value, str) and value.strip() != ""


def derive_namespace(path):
    """Derive a tag namespace from an extra config filename.

    `XDConfig.json` -> None (treated as if it were the main config — caller
    decides). `XDConfig-CN-Test.json` -> `cn-test`. Anything that does not
    start with `XDConfig` is just stem-lowercased so users can name files
    however they want."""
    stem = Path(path).stem
    if stem.lower().startswith("xdconfig"):
        rest = stem[len("xdconfig"):].lstrip("-_.")
        return rest.lower() or None
    return stem.lower() or None


def build_owner_entries(config, namespace=None):
    bundle_id = env("PRODUCT_BUNDLE_IDENTIFIER", "")
    cn = is_cn(config)
    entries = []  # (tag, url_schemes, query_schemes)

    ns_prefix = (namespace + ".") if namespace else ""

    def tag(suffix):
        return "xdsdk." + ns_prefix + suffix

    cid = config.get("client_id")
    if non_empty(cid):
        entries.append((tag("platform"), ["xd" + cid], []))

    tap = config.get("tapsdk") or {}
    if non_empty(tap.get("client_id")):
        tap_query = "tapsdk" if cn else "tapiosdk"
        # taptap is required by XDGTapSDK4WrapperSDK's canOpenURL:taptap:// check
        entries.append((tag("tap"), ["tt" + tap["client_id"]], [tap_query, "taptap"]))

    # Field names below mirror the snake_case keys consumed by XDConfigManager
    # / XDWeChatInfo / XDQQInfo / etc. — do NOT change to camelCase.
    wechat = config.get("wechat") or {}
    if non_empty(wechat.get("app_id")) and non_empty(wechat.get("universal_link")):
        entries.append((
            tag("wechat"),
            [wechat["app_id"]],
            ["weixin", "weixinULAPI", "weixinURLParamsAPI"],
        ))

    qq = config.get("qq") or {}
    if non_empty(qq.get("app_id")) and non_empty(qq.get("universal_link")):
        entries.append((
            tag("qq"),
            ["tencent" + qq["app_id"]],
            ["mqqopensdkapiV2", "mqq", "mqqapi", "tim", "mqqopensdknopasteboard"],
        ))

    weibo = config.get("weibo") or {}
    if non_empty(weibo.get("app_id")) and non_empty(weibo.get("universal_link")):
        entries.append((
            tag("weibo"),
            ["wb" + weibo["app_id"]],
            ["sinaweibo", "weibosdk", "weibosdk2.5", "weibosdk3.3"],
        ))

    xhs = config.get("xhs") or {}
    # XDXHSInfo reads `app_id_ios` specifically (Android lives in `app_id_android`).
    if non_empty(xhs.get("app_id_ios")):
        entries.append((tag("xhs"), ["xhs" + xhs["app_id_ios"]], ["xhsdiscover"]))

    douyin = config.get("douyin") or {}
    if non_empty(douyin.get("app_id")):
        entries.append((
            tag("douyin"),
            [douyin["app_id"]],
            ["douyinopensdk", "douyinliteopensdk", "douyinsharesdk", "snssdk1128"],
        ))

    kuaishou = config.get("kuaishou") or {}
    if non_empty(kuaishou.get("app_id")) and non_empty(kuaishou.get("universal_link")):
        entries.append((
            tag("kuaishou"),
            [kuaishou["app_id"]],
            [
                "kwai", "kwaiAuth2", "kwaiopenapi", "KwaiBundleToken",
                "kwai.clip.multi", "KwaiSDKMediaV2", "ksnebula",
            ],
        ))

    facebook = config.get("facebook") or {}
    if non_empty(facebook.get("app_id")):
        entries.append((
            tag("facebook"),
            ["fb" + facebook["app_id"]],
            ["fbapi", "fb-messenger-share-api", "instagram"],
        ))

    line = config.get("line") or {}
    if non_empty(line.get("channel_id")) and bundle_id:
        entries.append((tag("line"), ["line3rdp." + bundle_id], ["lineauth2"]))

    twitter = config.get("twitter") or {}
    if non_empty(twitter.get("consumer_key")) and non_empty(twitter.get("consumer_secret")):
        entries.append((
            tag("twitter"),
            ["tdsg.twitter." + twitter["consumer_key"]],
            ["twitterauth"],
        ))

    google = config.get("google") or {}
    gid = google.get("CLIENT_ID")
    if non_empty(gid):
        reversed_id = ".".join(reversed(gid.split(".")))
        entries.append((tag("google"), [reversed_id], []))

    tiktok = config.get("tiktok") or {}
    if non_empty(tiktok.get("client_key")):
        entries.append((
            tag("tiktok"),
            [tiktok["client_key"]],
            ["tiktokopensdk", "tiktoksharesdk", "snssdk1180", "snssdk1233"],
        ))

    return entries


def build_uop_entries():
    """DouYin CPS (XDSDKDouYinGame): app_id lives in a separate UOPSDKConfig.json
    bundled with the app, mirroring XDDouYinGameWrapper's runtime check. The
    bundled UOPSDKConfig.json is a singleton, so this is not namespaced."""
    uop_path = find_uop_config_path()
    if uop_path is None:
        return []
    try:
        uop_config = json.loads(uop_path.read_text(encoding="utf-8"))
    except (OSError, ValueError):
        return []
    uop_app_id = uop_config.get("app_id")
    if not non_empty(uop_app_id):
        return []
    return [("xdsdk.douyincps", ["dygame" + uop_app_id], [])]


def collect_warnings(config, plist):
    msgs = []
    if config.get("idfa_enabled") and not non_empty(plist.get("NSUserTrackingUsageDescription")):
        msgs.append(
            "idfa_enabled=true but NSUserTrackingUsageDescription is missing from Info.plist"
        )
    firebase = config.get("firebase") or {}
    if firebase.get("enableTrack"):
        srcroot = env("SRCROOT")
        if srcroot and not list(Path(srcroot).rglob("GoogleService-Info.plist")):
            msgs.append(
                "firebase.enableTrack=true; GoogleService-Info.plist not found under SRCROOT"
            )
    line = config.get("line") or {}
    if non_empty(line.get("channel_id")) and not env("PRODUCT_BUNDLE_IDENTIFIER"):
        msgs.append(
            "Line is enabled but PRODUCT_BUNDLE_IDENTIFIER is empty; line URL scheme not configured"
        )
    return msgs


def merge_url_types(existing, entries):
    kept = [
        e for e in (existing or [])
        if not str(e.get("CFBundleURLName", "")).startswith(OWNER_PREFIX)
    ]
    added = []
    for tag, urls, _ in entries:
        if not urls:
            continue
        added.append({
            "CFBundleURLName": tag,
            "CFBundleTypeRole": "Editor",
            "CFBundleURLSchemes": list(urls),
        })
    return kept + added


def build_top_level_keys(config):
    """Top-level Info.plist string keys owned by the script."""
    out = {}  # dict preserves insertion order
    facebook = config.get("facebook") or {}
    if non_empty(facebook.get("app_id")):
        out["FacebookAppID"] = facebook["app_id"]
    if non_empty(facebook.get("client_token")):
        out["FacebookClientToken"] = facebook["client_token"]
    return out


def diff_top_level_keys(plist, sidecar, new_managed):
    """Return (changed, ordered_managed_keys). `changed` is True when the
    desired plist state differs from the current one for any managed key."""
    previously_managed = list(sidecar or [])
    new_keys = list(new_managed.keys())
    new_keys_set = set(new_keys)
    changed = False
    for k in previously_managed:
        if k not in new_keys_set and k in plist:
            changed = True
            break
    if not changed:
        for k, v in new_managed.items():
            if plist.get(k) != v:
                changed = True
                break
    return changed, new_keys


def apply_top_level_keys(plist, sidecar, new_managed):
    """Mutate plist in place: drop previously-managed keys that are gone, then
    set the new ones."""
    previously_managed = list(sidecar or [])
    new_keys_set = set(new_managed.keys())
    for k in previously_managed:
        if k not in new_keys_set and k in plist:
            del plist[k]
    for k, v in new_managed.items():
        plist[k] = v


def merge_queries(existing, sidecar, entries):
    previously_managed = set(sidecar or [])
    new_managed = []
    for _, _, queries in entries:
        for q in queries:
            if q not in new_managed:
                new_managed.append(q)
    new_managed_set = set(new_managed)

    out = []
    for s in (existing or []):
        if s in previously_managed and s not in new_managed_set:
            continue
        if s in out:
            continue
        out.append(s)
    for q in new_managed:
        if q not in out:
            out.append(q)
    return out, new_managed


def dedupe_entries(entries):
    """Drop entries whose URL scheme list already appeared earlier (likely
    because two XDConfig variants share the same Facebook / Line / Twitter /
    platform appId). The first occurrence wins, so the main config keeps its
    unnamespaced `xdsdk.<platform>` tag and earlier extras win over later
    ones. Query schemes are de-duplicated separately downstream by
    `merge_queries`, so we don't need to track them here."""
    seen_urls = set()
    seen_tags = set()
    out = []
    for tag, urls, queries in entries:
        urls_key = tuple(urls)
        if urls_key in seen_urls:
            continue
        if tag in seen_tags:
            # Same tag with different urls would silently overwrite later — skip
            # and let the existing entry win. In practice this only happens if
            # caller passes two configs with identical filenames.
            continue
        seen_urls.add(urls_key)
        seen_tags.add(tag)
        out.append((tag, urls, queries))
    return out


def collect_extra_config_paths(args):
    """Order: --config-extra flags first (CLI), then env-var entries, dedup
    while preserving order. Empty entries are skipped."""
    seen = set()
    out = []
    for raw in (args.config_extra or []):
        if raw and raw not in seen:
            seen.add(raw)
            out.append(raw)
    env_blob = env("XDSDK_EXTRA_CONFIG_PATHS")
    if env_blob:
        for raw in env_blob.split(":"):
            raw = raw.strip()
            if raw and raw not in seen:
                seen.add(raw)
                out.append(raw)
    return [Path(p) for p in out]


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--mode", choices=["patch", "check"], default="patch")
    parser.add_argument("--config", help="explicit XDConfig.json path (main)")
    parser.add_argument(
        "--config-extra",
        action="append",
        default=[],
        help="extra XDConfig.json path (repeatable). Tags are namespaced as "
             "xdsdk.<filename>.<platform> so multi-environment apps can keep "
             "several configs side by side.",
    )
    parser.add_argument("--info-plist", help="explicit Info.plist path")
    args = parser.parse_args()

    config_path = Path(args.config) if args.config else find_config_path()
    if not config_path or not config_path.exists():
        print("error: XDConfig.json not found (looked at: {})".format(config_path),
              file=sys.stderr)
        sys.exit(1)

    plist_path = Path(args.info_plist) if args.info_plist else find_infoplist_path()
    if not plist_path or not plist_path.exists():
        print("error: Info.plist not found (looked at: {})".format(plist_path),
              file=sys.stderr)
        sys.exit(1)

    config = json.loads(config_path.read_text(encoding="utf-8"))
    entries = build_owner_entries(config)

    extra_paths = collect_extra_config_paths(args)
    extras = []  # list of (path, namespace, config) for downstream logging
    for ep in extra_paths:
        if not ep.exists():
            print("error: extra XDConfig not found: {}".format(ep), file=sys.stderr)
            sys.exit(1)
        ns = derive_namespace(ep)
        if not ns:
            print("error: cannot derive namespace from extra config filename: {}".format(ep),
                  file=sys.stderr)
            sys.exit(1)
        extra_cfg = json.loads(ep.read_text(encoding="utf-8"))
        entries.extend(build_owner_entries(extra_cfg, namespace=ns))
        extras.append((ep, ns, extra_cfg))

    # UOPSDKConfig and Facebook top-level keys are app-singletons; they only
    # come from the main config / bundled UOPSDKConfig.json.
    entries.extend(build_uop_entries())

    # Two configs that point at the same Facebook app (or share platform app id
    # because cn-test reuses cn's appId, etc.) would otherwise produce
    # duplicated CFBundleURLTypes entries. Keep the first occurrence.
    entries = dedupe_entries(entries)

    with plist_path.open("rb") as f:
        plist = plistlib.load(f)

    new_url_types = merge_url_types(plist.get("CFBundleURLTypes"), entries)
    new_queries, new_sidecar = merge_queries(
        plist.get("LSApplicationQueriesSchemes"),
        plist.get(QUERY_SIDECAR_KEY),
        entries,
    )
    new_top_level = build_top_level_keys(config)
    top_level_changed, new_top_sidecar = diff_top_level_keys(
        plist, plist.get(TOP_LEVEL_SIDECAR_KEY), new_top_level
    )
    top_sidecar_changed = (plist.get(TOP_LEVEL_SIDECAR_KEY) or []) != new_top_sidecar

    changed = (
        plist.get("CFBundleURLTypes") != new_url_types
        or plist.get("LSApplicationQueriesSchemes") != new_queries
        or plist.get(QUERY_SIDECAR_KEY) != new_sidecar
        or top_level_changed
        or top_sidecar_changed
    )

    warnings = collect_warnings(config, plist)

    if args.mode == "check":
        if changed:
            print("error: Info.plist out of sync with {}; run patch mode".format(config_path.name),
                  file=sys.stderr)
            sys.exit(2)
        for w in warnings:
            print("warning: " + w)
        return

    if changed:
        plist["CFBundleURLTypes"] = new_url_types
        plist["LSApplicationQueriesSchemes"] = new_queries
        plist[QUERY_SIDECAR_KEY] = new_sidecar
        apply_top_level_keys(plist, plist.get(TOP_LEVEL_SIDECAR_KEY), new_top_level)
        plist[TOP_LEVEL_SIDECAR_KEY] = new_top_sidecar
        with plist_path.open("wb") as f:
            plistlib.dump(plist, f, sort_keys=False)
        print("Patched {}".format(plist_path))
        print("  main config: {}".format(config_path))
        for ep, ns, _ in extras:
            print("  extra config [{}]: {}".format(ns, ep))
        for tag, urls, queries in entries:
            print("  {}: urls={} queries={}".format(tag, urls, queries))
        for k in new_top_sidecar:
            print("  top-level {}={}".format(k, new_top_level[k]))
    else:
        print("Info.plist already in sync with {}".format(config_path.name))

    for w in warnings:
        print("warning: " + w)


if __name__ == "__main__":
    main()
