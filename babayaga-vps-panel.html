#!/usr/bin/env bash
# BABAYAGA VPS agent installer v3 (Debian/Ubuntu). Run as root:  bash install.sh
# Run it on EVERY VPS. The VPS list lives in an encrypted file on GitHub (made with babayaga-admin.html);
# the panel fetches it and the master VPS connects to the others, so the browser trusts only ONE cert.
# Options (env): PORT=8443  ROTATE=1 (generate a new token)
set -euo pipefail
[ "$(id -u)" = 0 ] || { echo "Run as root."; exit 1; }
command -v python3 >/dev/null || { echo "python3 is required."; exit 1; }
[ -f /etc/xray/config.json ] || { echo "/etc/xray/config.json not found."; exit 1; }
PORT="${PORT:-8443}"
DIR=/opt/babayaga
mkdir -p "$DIR"

cat > "$DIR/agent.py" <<'BBY_PY_EOF'
#!/usr/bin/env python3
"""BABAYAGA VPN agent - manages SSH + Xray accounts. Token-protected HTTPS API. Run as root."""
import os, re, sys, json, ssl, time, uuid, hmac, hashlib, shutil, subprocess, threading, datetime, http.client
from http.server import ThreadingHTTPServer, BaseHTTPRequestHandler

BASE = os.environ.get("BBY_DIR", "/opt/babayaga")
CONF = json.load(open(os.path.join(BASE, "agent.json")))
XRAY_CONFIG = os.environ.get("BBY_XRAY_CONFIG", "/etc/xray/config.json")
DOMAIN_FILE = os.environ.get("BBY_DOMAIN_FILE", "/etc/xray/domain")
NS_FILE = os.environ.get("BBY_NS_FILE", "/etc/xray/scdomain")
NO_XRAY = os.environ.get("BBY_NO_XRAY") == "1"          # tests only: skip xray validation/restart
SERVICES = ["xray", "ssh", "ws-dropbear", "ws-stunnel", "slipstream-rust-server", "slipstream-rust-xray"]
PROTECTED = {"root", "admin"}
LOCK = threading.Lock()

PROTOS = {
    "vless-ws":     {"marker": "#vless",       "kind": "vless"},
    "vmess-ws":     {"marker": "#vmess",       "kind": "vmess"},
    "trojan-ws":    {"marker": "#trojanws",    "kind": "trojan"},
    "vless-xhttp":  {"marker": "#vlessxhttp",  "kind": "vless"},
    "vmess-xhttp":  {"marker": "#vmessxhttp",  "kind": "vmess"},
    "trojan-xhttp": {"marker": "#trojanxhttp", "kind": "trojan"},
    "vless-slip":   {"marker": "#slipvless",   "kind": "vless"},
}
MARKER_TO_PROTO = {v["marker"]: k for k, v in PROTOS.items()}
USER_RE = re.compile(r"^[a-z][a-z0-9_-]{2,19}$")
PASS_RE = re.compile(r"^[A-Za-z0-9@#%^&*_+=.,!-]{4,32}$")
ENTRY_RE = re.compile(r"^#& (\S+) (\d{4}-\d{2}-\d{2})$")
SECRET_RE = re.compile(r'"(?:id|password)"\s*:\s*"([^"]+)"')


class ApiError(Exception):
    def __init__(self, msg, status=400):
        super().__init__(msg)
        self.status = status


def run(cmd, inp=None, check=True):
    try:
        p = subprocess.run(cmd, input=inp, capture_output=True, text=True, timeout=40)
    except FileNotFoundError:
        p = subprocess.CompletedProcess(cmd, 127, "", "%s not found" % cmd[0])
    if check and p.returncode != 0:
        raise ApiError("%s failed: %s" % (cmd[0], (p.stderr or p.stdout).strip()[-300:]), 500)
    return p


def today():
    return datetime.date.today()


def check_user(u):
    if not isinstance(u, str) or not USER_RE.match(u):
        raise ApiError("Invalid username (3-20 chars: a-z, 0-9, _ or -, must start with a letter)")
    return u


def check_days(d):
    try:
        d = int(d)
    except Exception:
        raise ApiError("Invalid days")
    if d < 1 or d > 3650:
        raise ApiError("Days must be 1-3650")
    return d


def extend(current_iso, days):
    base = today()
    if current_iso:
        try:
            cur = datetime.date.fromisoformat(current_iso)
            if cur > base:
                base = cur
        except ValueError:
            pass
    return (base + datetime.timedelta(days=days)).isoformat()


# ---------------------------------------------------------------- Xray
def read_lines():
    with open(XRAY_CONFIG, "r", encoding="utf-8") as f:
        return f.read().splitlines()


def xray_parse(lines):
    out, cur, i = [], None, 0
    while i < len(lines):
        s = lines[i].strip()
        if s in MARKER_TO_PROTO:
            cur = MARKER_TO_PROTO[s]
            i += 1
            continue
        m = ENTRY_RE.match(s)
        if cur and m and i + 1 < len(lines) and lines[i + 1].lstrip().startswith("},{"):
            sec = SECRET_RE.search(lines[i + 1])
            out.append({"proto": cur, "user": m.group(1), "exp": m.group(2), "secret": sec.group(1) if sec else ""})
            i += 2
            continue
        i += 1
    return out


def xray_apply(lines):
    tmp = os.path.join(os.path.dirname(XRAY_CONFIG), "config.panel-test.json")
    with open(tmp, "w", encoding="utf-8") as f:
        f.write("\n".join(lines) + "\n")
    try:
        st = os.stat(XRAY_CONFIG)
        os.chmod(tmp, st.st_mode & 0o777)
        os.chown(tmp, st.st_uid, st.st_gid)
    except Exception:
        pass
    if not NO_XRAY:
        p = run(["xray", "run", "-test", "-config", tmp], check=False)
        if p.returncode != 0:
            os.remove(tmp)
            raise ApiError("Xray rejected the new config: " + (p.stdout + p.stderr).strip()[-300:], 500)
    shutil.copy2(XRAY_CONFIG, XRAY_CONFIG + ".bak-panel")
    os.replace(tmp, XRAY_CONFIG)
    if not NO_XRAY:
        run(["systemctl", "restart", "xray"])
        time.sleep(1.2)
        if run(["systemctl", "is-active", "--quiet", "xray"], check=False).returncode != 0:
            shutil.copy2(XRAY_CONFIG + ".bak-panel", XRAY_CONFIG)
            run(["systemctl", "restart", "xray"], check=False)
            raise ApiError("Xray failed to start; previous config was restored", 500)


def xray_list():
    with LOCK:
        entries = xray_parse(read_lines())
    users = {}
    for e in entries:
        u = users.setdefault(e["user"], {"user": e["user"], "exp": e["exp"], "entries": []})
        u["entries"].append({"proto": e["proto"], "secret": e["secret"]})
        u["exp"] = max(u["exp"], e["exp"])
    return sorted(users.values(), key=lambda x: x["user"])


def xray_add(user, days, protos):
    check_user(user)
    days = check_days(days)
    if not isinstance(protos, list) or not protos or any(p not in PROTOS for p in protos):
        raise ApiError("Choose at least one valid protocol")
    protos = list(dict.fromkeys(protos))
    with LOCK:
        lines = read_lines()
        if any(e["user"] == user and e["proto"] in protos for e in xray_parse(lines)):
            raise ApiError("User already exists on a selected protocol", 409)
        exp = extend(None, days)
        secret = str(uuid.uuid4())
        entry = {
            "vless": '},{"id":"%s","email":"%s"' % (secret, user),
            "vmess": '},{"id":"%s","alterId":0,"email":"%s"' % (secret, user),
            "trojan": '},{"password":"%s","email":"%s"' % (secret, user),
        }
        out, found = [], set()
        for ln in lines:
            out.append(ln)
            s = ln.strip()
            for p in protos:
                if s == PROTOS[p]["marker"]:
                    out.append("#& %s %s" % (user, exp))
                    out.append(entry[PROTOS[p]["kind"]])
                    found.add(p)
        if found != set(protos):
            raise ApiError("Marker not found in config for: " + ", ".join(sorted(set(protos) - found)))
        xray_apply(out)
    return {"user": user, "exp": exp, "secret": secret, "protos": protos}


def _strip_user(lines, user):
    out, i, removed = [], 0, 0
    pat = re.compile(r"^#& %s \d{4}-\d{2}-\d{2}$" % re.escape(user))
    while i < len(lines):
        if pat.match(lines[i].strip()) and i + 1 < len(lines) and lines[i + 1].lstrip().startswith("},{"):
            i += 2
            removed += 1
            continue
        out.append(lines[i])
        i += 1
    return out, removed


def xray_delete(user, _lock=True):
    check_user(user)
    with LOCK:
        out, removed = _strip_user(read_lines(), user)
        if not removed:
            raise ApiError("User not found", 404)
        xray_apply(out)
    return {"removed": removed}


def xray_renew(user, days):
    check_user(user)
    days = check_days(days)
    with LOCK:
        lines = read_lines()
        mine = [e for e in xray_parse(lines) if e["user"] == user]
        if not mine:
            raise ApiError("User not found", 404)
        exp = extend(max(e["exp"] for e in mine), days)
        pat = re.compile(r"^(\s*)#& %s \d{4}-\d{2}-\d{2}$" % re.escape(user))
        out = [pat.sub(lambda m: "%s#& %s %s" % (m.group(1), user, exp), ln.rstrip()) for ln in lines]
        xray_apply(out)
    return {"exp": exp}


def xray_purge():
    with LOCK:
        lines = read_lines()
        expired = {e["user"] for e in xray_parse(lines) if e["exp"] < today().isoformat()}
        if not expired:
            return 0
        for u in expired:
            lines, _ = _strip_user(lines, u)
        xray_apply(lines)
        return len(expired)


# ---------------------------------------------------------------- SSH
def _shadow():
    d = {}
    try:
        with open("/etc/shadow") as f:
            for line in f:
                p = line.rstrip("\n").split(":")
                if len(p) >= 8:
                    d[p[0]] = p
    except Exception:
        pass
    return d


def _sessions():
    cnt = {}
    p = run(["ps", "-eo", "user:32=,comm="], check=False)
    for line in p.stdout.splitlines():
        parts = line.split()
        if len(parts) == 2 and parts[1] in ("sshd", "dropbear"):
            cnt[parts[0]] = cnt.get(parts[0], 0) + 1
    return cnt


def ssh_list():
    sh, sess, out = _shadow(), _sessions(), []
    with open("/etc/passwd") as f:
        for line in f:
            p = line.rstrip("\n").split(":")
            if len(p) < 7:
                continue
            name, uid, shell = p[0], int(p[2]), p[6]
            if uid < 1000 or uid >= 65534 or name in PROTECTED:
                continue
            if shell not in ("/bin/false", "/usr/sbin/nologin", "/sbin/nologin"):
                continue
            exp, locked = None, False
            s = sh.get(name)
            if s:
                locked = s[1].startswith("!") or s[1].startswith("*")
                if s[7].isdigit():
                    exp = (datetime.date(1970, 1, 1) + datetime.timedelta(days=int(s[7]))).isoformat()
            out.append({"user": name, "exp": exp, "locked": locked, "sessions": sess.get(name, 0)})
    return sorted(out, key=lambda x: x["user"])


def _ssh_managed(user):
    check_user(user)
    if user in PROTECTED:
        raise ApiError("Protected account", 403)
    for u in ssh_list():
        if u["user"] == user:
            return u
    raise ApiError("User not found", 404)


def ssh_add(user, password, days):
    check_user(user)
    days = check_days(days)
    if not isinstance(password, str) or not PASS_RE.match(password):
        raise ApiError("Password must be 4-32 chars (letters, digits, @#%^&*_+=.,!-)")
    if user in PROTECTED:
        raise ApiError("Protected account", 403)
    if run(["id", user], check=False).returncode == 0:
        raise ApiError("User already exists on this server", 409)
    exp = extend(None, days)
    run(["useradd", "-M", "-s", "/bin/false", "-e", exp, user])
    p = run(["chpasswd"], inp="%s:%s\n" % (user, password), check=False)
    if p.returncode != 0:
        run(["userdel", "-f", user], check=False)
        raise ApiError("Could not set password", 500)
    return {"user": user, "exp": exp}


def ssh_renew(user, days):
    days = check_days(days)
    u = _ssh_managed(user)
    exp = extend(u["exp"], days)
    run(["chage", "-E", exp, user])
    run(["usermod", "-U", user], check=False)
    return {"exp": exp}


def ssh_delete(user):
    _ssh_managed(user)
    run(["pkill", "-KILL", "-u", user], check=False)
    run(["userdel", "-f", user])
    return {}


# ---------------------------------------------------------------- status
def _read(path):
    try:
        with open(path) as f:
            return f.read().strip()
    except Exception:
        return ""


def status():
    mem = {}
    for line in _read("/proc/meminfo").splitlines():
        k, _, v = line.partition(":")
        mem[k] = int(v.split()[0]) if v.split() else 0
    du = shutil.disk_usage("/")
    svc = {s: run(["systemctl", "is-active", s], check=False).stdout.strip() == "active" for s in SERVICES}
    ports = sorted({int(m.group(1)) for m in re.finditer(r":(\d+)\s+.*sshd", run(["ss", "-tlnp"], check=False).stdout)})
    up = _read("/proc/uptime").split()
    return {
        "domain": _read(DOMAIN_FILE), "ns_domain": _read(NS_FILE), "hostname": os.uname().nodename,
        "uptime_s": int(float(up[0])) if up else 0, "load": _read("/proc/loadavg").split()[:3],
        "mem_total_mb": mem.get("MemTotal", 0) // 1024, "mem_avail_mb": mem.get("MemAvailable", 0) // 1024,
        "disk_total_gb": round(du.total / 2**30, 1), "disk_used_gb": round(du.used / 2**30, 1),
        "services": svc, "ssh_ports": ports, "protos": list(PROTOS.keys()),
    }


# ---------------------------------------------------------------- fleet (master mode)
# One panel link manages many VPS: this agent keeps the list of other agents (URL + token)
# in fleet.json (root-only) and forwards requests to them server-side, so the browser only
# ever talks to THIS server (one certificate, one token).
FLEET_FILE = os.path.join(BASE, "fleet.json")
FLOCK = threading.Lock()
ALLOWED = {("GET", "status"), ("GET", "ssh"), ("POST", "ssh"), ("POST", "ssh/renew"), ("POST", "ssh/delete"),
           ("GET", "xray"), ("POST", "xray"), ("POST", "xray/renew"), ("POST", "xray/delete")}


def fleet_load():
    try:
        with open(FLEET_FILE) as f:
            d = json.load(f)
        return d if isinstance(d, list) else []
    except Exception:
        return []


def fleet_save(d):
    tmp = FLEET_FILE + ".tmp"
    fd = os.open(tmp, os.O_WRONLY | os.O_CREAT | os.O_TRUNC, 0o600)
    with os.fdopen(fd, "w") as f:
        json.dump(d, f)
    os.replace(tmp, FLEET_FILE)


def _parse_url(url):
    m = re.match(r"^https://([A-Za-z0-9.-]+|\[[0-9a-fA-F:]+\])(?::(\d{1,5}))?/?$", url or "")
    if not m:
        raise ApiError("URL must look like https://IP-or-domain:8443")
    port = int(m.group(2) or 443)
    if not 1 <= port <= 65535:
        raise ApiError("Bad port")
    return m.group(1).strip("[]"), port


def remote_call(v, method, sub, body=None):
    host, port = _parse_url(v["url"])
    ctx = ssl.SSLContext(ssl.PROTOCOL_TLS_CLIENT)
    ctx.check_hostname = False
    ctx.verify_mode = ssl.CERT_NONE      # agents use self-signed certs; we pin the fingerprint instead
    conn = http.client.HTTPSConnection(host, port, timeout=30, context=ctx)
    try:
        conn.connect()
        fp = hashlib.sha256(conn.sock.getpeercert(True)).hexdigest()
        if v.get("fp") and not hmac.compare_digest(fp, v["fp"]):
            raise ApiError("Certificate of %s changed. Remove it and add it again." % v.get("name", "VPS"), 502)
        hdr = {"Authorization": "Bearer " + v["token"]}
        data = None
        if body is not None:
            data = json.dumps(body).encode()
            hdr["Content-Type"] = "application/json"
        conn.request(method, "/api/" + sub, body=data, headers=hdr)
        r = conn.getresponse()
        raw = r.read(1 << 20)
        try:
            j = json.loads(raw or b"{}")
        except Exception:
            j = {"ok": False, "error": "Bad reply from VPS"}
        return r.status, j, fp
    except ApiError:
        raise
    except Exception as e:
        raise ApiError("Cannot reach %s: %s" % (v.get("name", "VPS"), e), 502)
    finally:
        conn.close()


def _norm(u):
    return (u or "").strip().rstrip("/").lower()


def fleet_list():
    out = [{"id": "local", "name": os.uname().nodename + " (master)", "url": "this server"}]
    with FLOCK:
        for v in fleet_load():
            out.append({"id": v["id"], "name": v["name"], "url": v["url"],
                        "tsig": hashlib.sha256(v["token"].encode()).hexdigest()})
    return {"vps": out}


def fleet_add(name, url, token):
    """Add a VPS, or update it (name/token) when the same URL is already in the list."""
    name = (name if isinstance(name, str) else "").strip()[:40] or "VPS"
    url = (url if isinstance(url, str) else "").strip().rstrip("/")
    _parse_url(url)
    if not isinstance(token, str) or not 8 <= len(token.strip()) <= 200:
        raise ApiError("Missing or bad token")
    v = {"id": uuid.uuid4().hex[:8], "name": name, "url": url, "token": token.strip()}
    st, j, fp = remote_call(v, "GET", "status")
    if st == 401:
        raise ApiError("%s rejected the token" % name, 400)
    if st != 200 or not j.get("ok"):
        raise ApiError(j.get("error") or "VPS answered HTTP %d" % st, 502)
    v["fp"] = fp
    with FLOCK:
        d = fleet_load()
        for x in d:
            if _norm(x["url"]) == _norm(url):
                x.update({"name": name, "url": url, "token": v["token"], "fp": fp})
                fleet_save(d)
                return {"id": x["id"], "updated": True}
        d.append(v)
        fleet_save(d)
    return {"id": v["id"]}


def fleet_delete(vid):
    with FLOCK:
        d = fleet_load()
        n = [x for x in d if x["id"] != vid]
        if len(n) == len(d):
            raise ApiError("VPS not found", 404)
        fleet_save(n)
    return {}


def proxy(vid, method, sub, body):
    if (method, sub) not in ALLOWED:
        raise ApiError("Not found", 404)
    if vid == "local":
        return ROUTES[(method, "/api/" + sub)](body)
    with FLOCK:
        v = next((x for x in fleet_load() if x["id"] == vid), None)
    if not v:
        raise ApiError("VPS not found", 404)
    st, j, _ = remote_call(v, method, sub, body if method == "POST" else None)
    if st == 401:
        raise ApiError("%s rejected its token" % v["name"], 502)
    if st != 200 or j.get("ok") is False:
        raise ApiError(j.get("error") or "HTTP %d" % st, st if 400 <= st < 600 else 502)
    j.pop("ok", None)
    return j


# ---------------------------------------------------------------- HTTP
def _body_json(h):
    n = int(h.headers.get("Content-Length") or 0)
    if n > 8192:
        raise ApiError("Body too large", 413)
    try:
        d = json.loads(h.rfile.read(n) or b"{}")
    except Exception:
        raise ApiError("Bad JSON")
    if not isinstance(d, dict):
        raise ApiError("Bad JSON")
    return d


ROUTES = {
    ("GET", "/api/status"): lambda b: status(),
    ("GET", "/api/ssh"): lambda b: {"users": ssh_list()},
    ("POST", "/api/ssh"): lambda b: ssh_add(b.get("user"), b.get("password"), b.get("days")),
    ("POST", "/api/ssh/renew"): lambda b: ssh_renew(b.get("user"), b.get("days")),
    ("POST", "/api/ssh/delete"): lambda b: ssh_delete(b.get("user")),
    ("GET", "/api/xray"): lambda b: {"users": xray_list()},
    ("POST", "/api/xray"): lambda b: xray_add(b.get("user"), b.get("days"), b.get("protos")),
    ("POST", "/api/xray/renew"): lambda b: xray_renew(b.get("user"), b.get("days")),
    ("POST", "/api/xray/delete"): lambda b: xray_delete(b.get("user")),
    ("GET", "/api/fleet"): lambda b: fleet_list(),
    ("POST", "/api/fleet"): lambda b: fleet_add(b.get("name"), b.get("url"), b.get("token")),
    ("POST", "/api/fleet/delete"): lambda b: fleet_delete(b.get("id")),
}


class Handler(BaseHTTPRequestHandler):
    timeout = 20
    server_version = "bby"

    def log_message(self, *a):
        pass

    def _send(self, code, payload, ctype="application/json"):
        body = payload if isinstance(payload, bytes) else json.dumps(payload).encode()
        self.send_response(code)
        self.send_header("Content-Type", ctype)
        self.send_header("Content-Length", str(len(body)))
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Access-Control-Allow-Headers", "Authorization, Content-Type")
        self.send_header("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
        self.send_header("Cache-Control", "no-store")
        self.end_headers()
        self.wfile.write(body)

    def _authed(self):
        tok = (self.headers.get("Authorization") or "")[7:].strip() if (self.headers.get("Authorization") or "").startswith("Bearer ") else ""
        ok = hmac.compare_digest(hashlib.sha256(tok.encode()).hexdigest(), CONF["token_sha256"])
        if not ok:
            time.sleep(1)
        return ok

    def do_OPTIONS(self):
        self._send(204, b"", "text/plain")

    def _handle(self, method):
        path = self.path.split("?")[0].rstrip("/") or "/"
        if method == "GET" and path in ("/", "/panel"):
            try:
                with open(os.path.join(BASE, "panel.html"), "rb") as f:
                    return self._send(200, f.read(), "text/html; charset=utf-8")
            except Exception:
                return self._send(404, {"ok": False, "error": "panel.html missing"})
        pm = re.match(r"^/api/v/([a-z0-9]{4,12})/(.+)$", path)
        if pm:
            fn = lambda b, pm=pm: proxy(pm.group(1), method, pm.group(2), b)
        else:
            fn = ROUTES.get((method, path))
        if not fn:
            return self._send(404, {"ok": False, "error": "Not found"})
        if not self._authed():
            return self._send(401, {"ok": False, "error": "Invalid token"})
        try:
            body = _body_json(self) if method == "POST" else {}
            res = fn(body)
            res["ok"] = True
            self._send(200, res)
        except ApiError as e:
            self._send(e.status, {"ok": False, "error": str(e)})
        except Exception as e:
            self._send(500, {"ok": False, "error": "Server error: %s" % e})

    def do_GET(self):
        self._handle("GET")

    def do_POST(self):
        self._handle("POST")


def maintenance(ctx):
    while True:
        time.sleep(3600)
        try:
            xray_purge()
        except Exception as e:
            print("purge error:", e, file=sys.stderr)
        if ctx is not None:
            try:
                ctx.load_cert_chain(CONF["cert"], CONF["key"])
            except Exception as e:
                print("cert reload error:", e, file=sys.stderr)


def main():
    port = int(CONF.get("port", 8443))
    httpd = ThreadingHTTPServer(("0.0.0.0", port), Handler)
    ctx = None
    if not CONF.get("allow_http"):
        ctx = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
        ctx.minimum_version = ssl.TLSVersion.TLSv1_2
        ctx.load_cert_chain(CONF["cert"], CONF["key"])
        httpd.socket = ctx.wrap_socket(httpd.socket, server_side=True, do_handshake_on_connect=False)
    try:
        xray_purge()
    except Exception as e:
        print("initial purge error:", e, file=sys.stderr)
    threading.Thread(target=maintenance, args=(ctx,), daemon=True).start()
    print("BABAYAGA agent listening on", port, flush=True)
    httpd.serve_forever()


if __name__ == "__main__":
    main()
BBY_PY_EOF

cat > "$DIR/panel.html" <<'BBY_HTML_EOF'
<!DOCTYPE html>
<html lang="tl">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<meta name="robots" content="noindex,nofollow">
<title>BABAYAGA VPS Panel</title>
<style>
:root{--bg:#0b0e0d;--panel:#121715;--panel2:#171e1b;--line:#243029;--text:#e8e4d8;--muted:#8a9a90;--ember:#ff7a3d;--ember-dim:#3a2217;--ok:#5fd68a;--bad:#ff6b6b;
--serif:Georgia,'Times New Roman',serif;--sans:system-ui,-apple-system,'Segoe UI',Roboto,sans-serif;--mono:ui-monospace,Menlo,Consolas,monospace}
*{box-sizing:border-box}html{-webkit-text-size-adjust:100%}
body{margin:0;background:var(--bg);color:var(--text);font:15px/1.5 var(--sans);padding:env(safe-area-inset-top,0) 0 calc(76px + env(safe-area-inset-bottom,0))}
header{padding:20px 16px 4px;max-width:780px;margin:0 auto}
header h1{font:800 24px/1.1 var(--serif);margin:0}
header p{margin:6px 0 0;color:var(--muted);font-size:13px}
#cur{display:inline-block;margin-top:8px;font:12px var(--mono);color:var(--ember);border:1px solid var(--ember-dim);padding:3px 10px;border-radius:99px}
main{max-width:780px;margin:0 auto;padding:6px 16px 24px}
section{display:none}section.on{display:block}
h2{font:600 18px/1.2 var(--serif);margin:18px 0 10px}
.hint{color:var(--muted);font-size:13px;margin:0 0 12px}
nav{position:fixed;left:0;right:0;bottom:0;background:#0e1311ee;backdrop-filter:blur(8px);border-top:1px solid var(--line);display:flex;padding:6px 6px calc(6px + env(safe-area-inset-bottom,0));z-index:5}
nav button{flex:1;background:none;border:0;color:var(--muted);font:500 13px var(--sans);padding:12px 4px;border-radius:10px}
nav button.on{color:var(--text);background:var(--ember-dim)}
.grid{display:grid;grid-template-columns:1fr 1fr;gap:10px}.grid .wide{grid-column:1/-1}
label.f{display:block;font-size:12.5px;color:var(--muted)}label.f>span{display:block;margin-bottom:4px}
input[type=text],input[type=number],input[type=password],select{width:100%;background:var(--panel2);color:var(--text);border:1px solid var(--line);border-radius:10px;padding:10px 11px;font:14px var(--mono);outline:none}
input:focus,select:focus{border-color:var(--ember)}
.chk{display:flex;flex-wrap:wrap;gap:8px;margin:6px 0}
.chk label{display:flex;align-items:center;gap:6px;background:var(--panel2);border:1px solid var(--line);border-radius:99px;padding:6px 12px;font-size:13px}
.chk input{accent-color:var(--ember)}
.btn{background:var(--panel2);color:var(--text);border:1px solid var(--line);border-radius:10px;padding:10px 14px;font:500 14px var(--sans)}
.btn.pri{background:var(--ember);border-color:var(--ember);color:#1a0d05;font-weight:600}
.btn.dng{color:var(--bad)}.btn.sm{padding:6px 10px;font-size:13px}.btn:disabled{opacity:.5}
.row{display:flex;gap:8px;flex-wrap:wrap;margin:10px 0}
.card{background:var(--panel);border:1px solid var(--line);border-radius:14px;margin:0 0 10px;padding:12px 14px}
.card.sel{border-color:var(--ember)}
.top{display:flex;gap:10px;align-items:center}
.dot{width:9px;height:9px;border-radius:50%;background:#56615b;flex:none}.dot.on{background:var(--ok)}.dot.bad{background:var(--bad)}
.ttl{flex:1;min-width:0}.ttl strong{display:block;font-weight:600;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.ttl small{display:block;color:var(--muted);font:12px var(--mono);overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.chip{font:11px var(--mono);color:var(--ember);border:1px solid var(--ember-dim);padding:2px 8px;border-radius:99px}
.chip.exp{color:var(--bad);border-color:#5a2a2a}
.empty{border:1px dashed var(--line);border-radius:14px;padding:22px 16px;text-align:center;color:var(--muted);margin-bottom:12px}
.kv{display:grid;grid-template-columns:auto 1fr;gap:4px 14px;font-size:14px}.kv b{color:var(--muted);font-weight:400}
.mono{font-family:var(--mono);font-size:12.5px;word-break:break-all}
.bar{height:6px;background:#222c27;border-radius:3px;overflow:hidden;margin:4px 0 10px}.bar i{display:block;height:100%;background:var(--ember)}
.link{display:flex;gap:8px;align-items:center;margin:6px 0}.link span{flex:1;min-width:0;font:12px var(--mono);color:var(--muted);overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.res{background:#0e1311;border:1px solid var(--ok);border-radius:12px;padding:12px;margin:10px 0;white-space:pre-wrap;font:12.5px/1.5 var(--mono)}
.warn{background:var(--ember-dim);border:1px solid #5a3321;border-radius:12px;padding:10px 12px;font-size:13px;margin:10px 0}
#login{display:none;max-width:780px;margin:0 auto;padding:6px 16px}body.noauth #login{display:block}body.noauth main{display:none}
#msg{position:fixed;left:12px;right:12px;bottom:calc(84px + env(safe-area-inset-bottom,0));max-width:756px;margin:0 auto;background:#1d2823;border:1px solid var(--line);border-radius:12px;padding:12px 14px;font-size:14px;display:none;z-index:9}
#msg.ok{border-color:var(--ok)}#msg.bad{border-color:var(--bad)}
@media(min-width:560px){.grid{grid-template-columns:1fr 1fr 1fr}}
</style>
</head>
<body>
<header><h1>BABAYAGA VPS Panel</h1><p>SSH at Xray accounts sa lahat ng VPS mo.</p><span id="cur">walang napiling VPS</span></header>
<div id="login"><div id="pp" style="display:none"><h2>Passphrase</h2><p class="hint">Ilagay ang passphrase ng listahan ng VPS (isang beses lang sa device na ito).</p><label class="f"><span>Passphrase</span><input type="password" id="p-pass" autocomplete="off"></label><div class="row"><button class="btn pri" id="p-go">Buksan</button></div></div><div id="manual"><h2>Mag-login</h2><p class="hint">Ilagay ang URL at token ng master VPS (isang beses lang). Ang master na ang kokonekta sa lahat ng ibang VPS.</p><label class="f"><span>URL ng master</span><input type="text" id="l-url" placeholder="https://IP-ng-master:8443" autocapitalize="off"></label><label class="f" style="margin-top:10px"><span>Token ng master</span><input type="password" id="l-token" autocomplete="off"></label><div class="row"><button class="btn pri" id="l-go">Pumasok</button></div></div><div id="l-err" class="warn" style="display:none"></div></div>
<main>
<section id="t-vps" class="on">
  <h2>Mga VPS</h2>
  <div id="vpsList"></div>
  <div class="warn">Galing sa GitHub ang listahan ng VPS. Para magdagdag, magbago o mag-alis, gamitin ang <a href="babayaga-admin.html" style="color:var(--ember)">admin page</a>.</div>
  <div class="row"><button class="btn" id="refresh">I-refresh mula sa GitHub</button><button class="btn dng" id="logout">Logout</button></div>
</section>

<section id="t-ov">
  <h2>Overview</h2><div id="ov"><div class="empty">Pumili muna ng VPS.</div></div>
</section>

<section id="t-ssh">
  <h2>Gumawa ng SSH account</h2>
  <div class="grid">
    <label class="f"><span>Username</span><input type="text" id="s-user" autocapitalize="off" autocomplete="off" placeholder="juan"></label>
    <label class="f"><span>Password</span><input type="text" id="s-pass" autocomplete="off"></label>
    <label class="f"><span>Araw</span><input type="number" id="s-days" value="30" min="1"></label>
  </div>
  <div class="chk" id="s-targets"></div>
  <div class="row"><button class="btn pri" id="s-create">Gumawa</button><button class="btn" id="s-gen">Gumawa ng password</button></div>
  <div id="s-result"></div>
  <h2>Mga SSH account</h2><div id="s-list"></div>
</section>

<section id="t-xr">
  <h2>Gumawa ng Xray account</h2>
  <div class="grid">
    <label class="f"><span>Username</span><input type="text" id="x-user" autocapitalize="off" autocomplete="off" placeholder="juan"></label>
    <label class="f"><span>Araw</span><input type="number" id="x-days" value="30" min="1"></label>
  </div>
  <p class="hint">Protocols:</p>
  <div class="chk" id="x-protos"></div>
  <p class="hint">Gagawin sa:</p>
  <div class="chk" id="x-targets"></div>
  <div class="row"><button class="btn pri" id="x-create">Gumawa</button></div>
  <div id="x-result"></div>
  <h2>Mga Xray account</h2><div id="x-list"></div>
</section>
</main>
<div id="msg"></div>
<nav>
  <button data-tab="vps" class="on">VPS</button><button data-tab="ov">Overview</button><button data-tab="ssh">SSH</button><button data-tab="xr">Xray</button>
</nav>

<script>
(function(){
"use strict";
const $=s=>document.querySelector(s);
const esc=s=>String(s??"").replace(/[&<>"']/g,c=>({"&":"&amp;","<":"&lt;",">":"&gt;",'"':"&quot;","'":"&#39;"}[c]));
const KEY="bby-master-v2";
const PROTOS=[["vless-ws","VLESS WS"],["vmess-ws","VMess WS"],["trojan-ws","Trojan WS"],["vless-xhttp","VLESS xhttp"],["vmess-xhttp","VMess xhttp"],["trojan-xhttp","Trojan xhttp"],["vless-slip","VLESS Slipstream"]];
const PATHS={"vless-ws":"/vless","vmess-ws":"/vmess","trojan-ws":"/trojan-ws","vless-xhttp":"/xhttp-vless","vmess-xhttp":"/xhttp-vmess","trojan-xhttp":"/xhttp-trojan"};
let F={token:"",master:"",pp:"",cur:null}, V=[], INFO={};
try{const r=localStorage.getItem(KEY);if(r)F=JSON.parse(r)}catch(e){}
const save=()=>{try{localStorage.setItem(KEY,JSON.stringify(F))}catch(e){}};
const cur=()=>V.find(v=>v.id===F.cur);
function msg(t,k){const m=$("#msg");m.textContent=t;m.className=k||"";m.style.display="block";clearTimeout(msg.t);msg.t=setTimeout(()=>m.style.display="none",4500)}
async function api(v,path,body){
  const url=(F.master||"").replace(/\/+$/,"")+(v?"/api/v/"+v.id+path.slice(4):path);
  let r;
  try{r=await fetch(url,{method:body?"POST":"GET",headers:Object.assign({Authorization:"Bearer "+F.token},body?{"Content-Type":"application/json"}:{}),body:body?JSON.stringify(body):undefined})}
  catch(e){throw new Error("Hindi maabot ang master VPS. Buksan muna ang URL niya sa Chrome at i-accept ang certificate, at siguraduhing bukas ang port.")}
  let j={};try{j=await r.json()}catch(e){}
  if(r.status===401&&j.error==="Invalid token"){F.token="";save();document.body.classList.add("noauth");throw new Error("Maling token.")}
  if(!r.ok||j.ok===false)throw new Error(j.error||("HTTP "+r.status));
  return j;
}
const copy=async t=>{try{await navigator.clipboard.writeText(t);msg("Nakopya na.","ok")}catch(e){msg("Hindi nakopya. Piliin nang manu-mano.","bad")}};
const days=iso=>Math.ceil((new Date(iso+"T23:59:59")-new Date())/864e5);
const expChip=iso=>{if(!iso)return `<span class="chip">walang expiry</span>`;const d=days(iso);return `<span class="chip ${d<0?"exp":""}">${d<0?"expired":d+" araw"} · ${esc(iso)}</span>`};
const fmtUp=s=>{const d=Math.floor(s/86400),h=Math.floor(s%86400/3600);return d+"d "+h+"h"};

/* tabs */
document.querySelectorAll("nav button").forEach(b=>b.onclick=()=>{
  if(document.body.classList.contains("noauth"))return msg("Mag-login muna sa taas.","bad");
  document.querySelectorAll("nav button").forEach(x=>x.classList.toggle("on",x===b));
  document.querySelectorAll("section").forEach(s=>s.classList.toggle("on",s.id==="t-"+b.dataset.tab));
  window.scrollTo(0,0);load(b.dataset.tab);
});
function load(tab){
  if(tab==="vps")renderVps();
  if(!cur()&&tab!=="vps")return;
  if(tab==="ov")loadOv(); if(tab==="ssh")loadSsh(); if(tab==="xr")loadXr();
}

/* VPS list */
function head(){$("#cur").textContent=cur()?cur().name:"walang napiling VPS"}
async function loadFleet(){const r=await api(null,"/api/fleet");V=r.vps;if(!cur())F.cur=V[0]?V[0].id:null;save()}
function renderVps(){
  head();
  $("#vpsList").innerHTML=V.length?V.map(v=>`<div class="card ${v.id===F.cur?"sel":""}"><div class="top"><span class="dot" id="d-${esc(v.id)}"></span>
    <span class="ttl"><strong>${esc(v.name)}</strong><small>${esc(v.url)}</small></span></div>
    <div class="row"><button class="btn sm" data-use="${esc(v.id)}">${v.id===F.cur?"Napili":"Piliin"}</button></div></div>`).join("")
    :`<div class="empty">Wala pang VPS.</div>`;
  V.forEach(v=>api(v,"/api/status").then(()=>{const d=$("#d-"+v.id);if(d)d.className="dot on"}).catch(()=>{const d=$("#d-"+v.id);if(d)d.className="dot bad"}));
}
$("#vpsList").addEventListener("click",e=>{
  const b=e.target.closest("button");if(!b||!b.dataset.use)return;
  F.cur=b.dataset.use;save();renderVps();
});

/* VPS list lives in a GitHub file (AES-GCM encrypted with a passphrase). Panel auto-fetches it. */
const GH=(()=>{const m=location.hostname.match(/^([^.]+)\.github\.io$/i),seg=location.pathname.split("/").filter(Boolean)[0];
  return m&&seg&&!/\.html?$/i.test(seg)?{owner:m[1],repo:seg,file:"vps.enc.json"}:{owner:"noelrubio143",repo:"babayagavpn",file:"vps.enc.json"}})();
const ub64=s=>Uint8Array.from(atob(s),c=>c.charCodeAt(0));
async function dec(f,pass){
  const km=await crypto.subtle.importKey("raw",new TextEncoder().encode(pass),"PBKDF2",false,["deriveKey"]);
  const k=await crypto.subtle.deriveKey({name:"PBKDF2",salt:ub64(f.salt),iterations:200000,hash:"SHA-256"},km,{name:"AES-GCM",length:256},false,["decrypt"]);
  return JSON.parse(new TextDecoder().decode(await crypto.subtle.decrypt({name:"AES-GCM",iv:ub64(f.iv)},k,ub64(f.data))));
}
async function sha(s){return [...new Uint8Array(await crypto.subtle.digest("SHA-256",new TextEncoder().encode(s)))].map(b=>b.toString(16).padStart(2,"0")).join("")}
async function ghFetch(){
  let r=await fetch(`https://api.github.com/repos/${GH.owner}/${GH.repo}/contents/${GH.file}`,{headers:{Accept:"application/vnd.github.raw+json"},cache:"no-store"}).catch(()=>null);
  if(!r||!r.ok)r=await fetch("./"+GH.file+"?t="+Date.now(),{cache:"no-store"}).catch(()=>null);
  if(!r||!r.ok)return null;
  try{return await r.json()}catch(e){return null}
}
const nu=u=>String(u||"").trim().replace(/\/+$/,"").toLowerCase();
async function syncFleet(c){
  await loadFleet();
  const want=(c.vps||[]).filter(x=>x&&/^https:\/\//.test(x.url||"")&&x.token);
  const have=new Map(V.filter(v=>v.id!=="local").map(v=>[nu(v.url),v]));
  let add=0,rm=0;const bad=[];
  for(const x of want){
    const nm=(x.name||"VPS").slice(0,40),h=have.get(nu(x.url));
    if(h&&h.tsig===await sha(x.token)&&h.name===nm)continue;
    try{await api(null,"/api/fleet",{name:nm,url:x.url,token:x.token});add++}catch(e){bad.push(nm+": "+e.message)}
  }
  const keep=new Set(want.map(x=>nu(x.url)));
  for(const [u,v] of have)if(!keep.has(u)){try{await api(null,"/api/fleet/delete",{id:v.id});rm++}catch(e){}}
  if(add||rm)await loadFleet();
  if(bad.length)msg(bad.join(" · "),"bad");
}
async function fromGithub(){
  const f=await ghFetch();
  if(!f||!f.data)return {err:"Wala pang file na "+GH.file+" sa GitHub repo mo. Buksan ang admin page para gawin ito."};
  if(!F.pp)return {need:true};
  let c;
  try{c=await dec(f,F.pp)}catch(e){F.pp="";save();return {need:true,err:"Maling passphrase."}}
  if(!c||!c.master||!/^https:\/\//.test(c.master.url||"")||!c.master.token)return {err:"Kulang ang master URL/token sa file. Ayusin sa admin page."};
  F.master=c.master.url.trim().replace(/\/+$/,"");F.token=c.master.token;save();
  try{await syncFleet(c)}catch(e){return {err:e.message}}
  return {ok:true};
}
function showApp(){document.body.classList.remove("noauth");$("#l-err").style.display="none";renderVps()}
function showLogin(pp,note){
  document.body.classList.add("noauth");
  $("#pp").style.display=pp?"block":"none";$("#manual").style.display=pp?"none":"block";
  $("#l-err").textContent=note||"";$("#l-err").style.display=note?"block":"none";
}
/* overview */
async function loadOv(){
  const v=cur();$("#ov").innerHTML=`<div class="empty">Kinukuha…</div>`;
  try{
    const s=await api(v,"/api/status");INFO[v.id]=s;
    const mp=s.mem_total_mb?Math.round((s.mem_total_mb-s.mem_avail_mb)/s.mem_total_mb*100):0, dp=s.disk_total_gb?Math.round(s.disk_used_gb/s.disk_total_gb*100):0;
    $("#ov").innerHTML=`<div class="card"><div class="kv"><b>Domain</b><span class="mono">${esc(s.domain||"—")}</span><b>NS domain</b><span class="mono">${esc(s.ns_domain||"—")}</span>
      <b>Uptime</b><span>${fmtUp(s.uptime_s)}</span><b>Load</b><span>${esc(s.load.join("  "))}</span><b>SSH ports</b><span class="mono">${esc(s.ssh_ports.join(", ")||"—")}</span></div></div>
      <div class="card"><div>RAM ${mp}% (${s.mem_total_mb-s.mem_avail_mb}/${s.mem_total_mb} MB)</div><div class="bar"><i style="width:${mp}%"></i></div>
      <div>Disk ${dp}% (${s.disk_used_gb}/${s.disk_total_gb} GB)</div><div class="bar"><i style="width:${dp}%"></i></div></div>
      <div class="card">${Object.entries(s.services).map(([k,ok])=>`<div class="top" style="margin:4px 0"><span class="dot ${ok?"on":"bad"}"></span><span class="mono">${esc(k)}</span></div>`).join("")}</div>`;
  }catch(e){$("#ov").innerHTML=`<div class="empty">${esc(e.message)}</div>`}
}
async function info(v){if(!INFO[v.id])INFO[v.id]=await api(v,"/api/status");return INFO[v.id]}

/* targets */
function renderTargets(el){
  el.innerHTML=V.map(v=>`<label><input type="checkbox" value="${v.id}" ${v.id===F.cur?"checked":""}> ${esc(v.name)}</label>`).join("");
}
const picked=el=>[...el.querySelectorAll("input:checked")].map(i=>V.find(v=>v.id===i.value)).filter(Boolean);
async function multi(targets,fn){
  const out=[];
  for(const v of targets){try{out.push({v,r:await fn(v)})}catch(e){out.push({v,err:e.message})}}
  return out;
}

/* SSH */
async function loadSsh(){
  renderTargets($("#s-targets"));
  const v=cur();$("#s-list").innerHTML=`<div class="empty">Kinukuha…</div>`;
  try{
    const r=await api(v,"/api/ssh");
    $("#s-list").innerHTML=r.users.length?r.users.map(u=>`<div class="card"><div class="top"><span class="dot ${u.sessions?"on":""}"></span>
      <span class="ttl"><strong>${esc(u.user)}</strong><small>${u.sessions} aktibong session</small></span>${expChip(u.exp)}</div>
      <div class="row"><button class="btn sm" data-renew="${esc(u.user)}">Dagdag na araw</button><button class="btn sm dng" data-del="${esc(u.user)}">Burahin</button></div></div>`).join("")
      :`<div class="empty">Wala pang SSH account.</div>`;
  }catch(e){$("#s-list").innerHTML=`<div class="empty">${esc(e.message)}</div>`}
}
const rnd=n=>{const c="abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ23456789";const a=new Uint32Array(n);crypto.getRandomValues(a);return [...a].map(x=>c[x%c.length]).join("")};
$("#s-gen").onclick=()=>$("#s-pass").value=rnd(10);
$("#s-create").onclick=async()=>{
  const user=$("#s-user").value.trim().toLowerCase(),pass=$("#s-pass").value||rnd(10),d=+$("#s-days").value,t=picked($("#s-targets"));
  if(!user||!t.length)return msg("Ilagay ang username at pumili ng VPS.","bad");
  $("#s-pass").value=pass;$("#s-create").disabled=true;
  const res=await multi(t,v=>api(v,"/api/ssh",{user,password:pass,days:d}));
  let html="";
  for(const x of res){
    if(x.err){html+=`<div class="warn"><b>${esc(x.v.name)}</b>: ${esc(x.err)}</div>`;continue}
    let s={};try{s=await info(x.v)}catch(e){}
    const txt=`BABAYAGA VPN · SSH\nServer: ${s.domain||x.v.url}\nPorts: ${(s.ssh_ports||[]).join(", ")}\nUsername: ${user}\nPassword: ${pass}\nExpires: ${x.r.exp}`;
    html+=`<div class="res">${esc(txt)}</div><div class="row"><button class="btn sm" data-copy="${esc(txt)}">Kopyahin</button></div>`;
  }
  $("#s-result").innerHTML=html;$("#s-create").disabled=false;loadSsh();
};
$("#s-list").addEventListener("click",async e=>{
  const b=e.target.closest("button");if(!b)return;const v=cur();
  try{
    if(b.dataset.renew){const d=prompt("Ilang araw ang idadagdag?","30");if(!d)return;const r=await api(v,"/api/ssh/renew",{user:b.dataset.renew,days:+d});msg("Bagong expiry: "+r.exp,"ok");loadSsh()}
    if(b.dataset.del&&confirm("Burahin ang account na "+b.dataset.del+"?")){await api(v,"/api/ssh/delete",{user:b.dataset.del});msg("Nabura na.","ok");loadSsh()}
  }catch(er){msg(er.message,"bad")}
});

/* Xray */
function makeLinks(dom,u,e){
  const n=encodeURIComponent(u+"-"+e.proto),p=PATHS[e.proto];if(!p)return null;
  const [k,net]=e.proto.split("-"),ep=encodeURIComponent(p);
  const x=net==="xhttp"?"&mode=auto":"";
  if(k==="vless")return `vless://${e.secret}@${dom}:443?encryption=none&security=tls&sni=${dom}&type=${net}&host=${dom}&path=${ep}${x}#${n}`;
  if(k==="trojan")return `trojan://${e.secret}@${dom}:443?security=tls&sni=${dom}&type=${net}&host=${dom}&path=${ep}${x}#${n}`;
  return "vmess://"+btoa(JSON.stringify({v:"2",ps:u+"-"+e.proto,add:dom,port:"443",id:e.secret,aid:"0",scy:"auto",net:net,type:"none",host:dom,path:p,tls:"tls",sni:dom}));
}
function xrCard(dom,u){
  const links=u.entries.map(e=>{const l=makeLinks(dom,u.user,e);const label=(PROTOS.find(p=>p[0]===e.proto)||[0,e.proto])[1];
    return l?`<div class="link"><span>${esc(label)}</span><button class="btn sm" data-copy="${esc(l)}">Kopyahin</button></div>`
            :`<div class="link"><span>${esc(label)} · UUID: ${esc(e.secret)}</span><button class="btn sm" data-copy="${esc(e.secret)}">Kopyahin</button></div>`}).join("");
  return `<div class="card"><div class="top"><span class="dot on"></span><span class="ttl"><strong>${esc(u.user)}</strong><small>${u.entries.length} protocol</small></span>${expChip(u.exp)}</div>
    <details style="margin-top:8px"><summary class="hint" style="cursor:pointer">Mga link</summary>${links}</details>
    <div class="row"><button class="btn sm" data-renew="${esc(u.user)}">Dagdag na araw</button><button class="btn sm dng" data-del="${esc(u.user)}">Burahin</button></div></div>`;
}
async function loadXr(){
  renderTargets($("#x-targets"));
  if(!$("#x-protos").children.length)$("#x-protos").innerHTML=PROTOS.map(p=>`<label><input type="checkbox" value="${p[0]}" ${p[0]==="vless-slip"?"":"checked"}> ${p[1]}</label>`).join("");
  const v=cur();$("#x-list").innerHTML=`<div class="empty">Kinukuha…</div>`;
  try{
    const [r,s]=await Promise.all([api(v,"/api/xray"),info(v)]);
    $("#x-list").innerHTML=r.users.length?r.users.map(u=>xrCard(s.domain||"DOMAIN",u)).join(""):`<div class="empty">Wala pang Xray account.</div>`;
  }catch(e){$("#x-list").innerHTML=`<div class="empty">${esc(e.message)}</div>`}
}
$("#x-create").onclick=async()=>{
  const user=$("#x-user").value.trim().toLowerCase(),d=+$("#x-days").value,t=picked($("#x-targets")),protos=[...$("#x-protos").querySelectorAll("input:checked")].map(i=>i.value);
  if(!user||!t.length||!protos.length)return msg("Ilagay ang username, protocol at VPS.","bad");
  $("#x-create").disabled=true;
  const res=await multi(t,v=>api(v,"/api/xray",{user,days:d,protos}));
  let html="";
  for(const x of res){
    if(x.err){html+=`<div class="warn"><b>${esc(x.v.name)}</b>: ${esc(x.err)}</div>`;continue}
    let s={};try{s=await info(x.v)}catch(e){}
    const dom=s.domain||"DOMAIN";
    const ls=x.r.protos.map(p=>makeLinks(dom,user,{proto:p,secret:x.r.secret})||("Slipstream UUID: "+x.r.secret));
    const txt=`BABAYAGA VPN · Xray (${x.v.name})\nUser: ${user}\nExpires: ${x.r.exp}\n\n`+ls.join("\n\n");
    html+=`<div class="res">${esc(txt)}</div><div class="row"><button class="btn sm" data-copy="${esc(txt)}">Kopyahin lahat</button></div>`;
  }
  $("#x-result").innerHTML=html;$("#x-create").disabled=false;loadXr();
};
$("#x-list").addEventListener("click",async e=>{
  const b=e.target.closest("button");if(!b||b.dataset.copy)return;const v=cur();
  try{
    if(b.dataset.renew){const d=prompt("Ilang araw ang idadagdag?","30");if(!d)return;const r=await api(v,"/api/xray/renew",{user:b.dataset.renew,days:+d});msg("Bagong expiry: "+r.exp,"ok");loadXr()}
    if(b.dataset.del&&confirm("Burahin ang "+b.dataset.del+" sa lahat ng Xray protocol? Magre-restart ang Xray sandali.")){await api(v,"/api/xray/delete",{user:b.dataset.del});msg("Nabura na.","ok");loadXr()}
  }catch(er){msg(er.message,"bad")}
});
document.addEventListener("click",e=>{const b=e.target.closest("[data-copy]");if(b)copy(b.dataset.copy)});

async function start(){
  if(!F.master&&location.port)F.master=location.origin;   /* served by the agent itself */
  if(GH){
    /* public github.io page: never show URL/token fields, only the passphrase box */
    const r=await fromGithub();
    if(r.ok)return showApp();
    return showLogin(true,r.err);
  }
  $("#l-url").value=F.master||"";
  if(!F.token||!F.master)return showLogin(false,"");
  try{await loadFleet()}catch(e){return showLogin(false,e.message)}
  showApp();
}
$("#l-go").onclick=()=>{
  const u=$("#l-url").value.trim().replace(/\/+$/,""),t=$("#l-token").value.trim();
  if(!/^https:\/\/[^\s\/]+$/.test(u)||!t)return msg("Ilagay ang https:// URL at token.","bad");
  F.master=u;F.token=t;save();$("#l-token").value="";start();
};
$("#p-go").onclick=()=>{const p=$("#p-pass").value;if(p){F.pp=p;save()}if(!F.pp)return;$("#p-pass").value="";start()};
$("#refresh").onclick=()=>{msg("Kinukuha…","ok");start()};
$("#logout").onclick=()=>{F.token="";F.pp="";F.cur=null;save();start()};
start();
})();
</script>
</body>
</html>
BBY_HTML_EOF

chmod 700 "$DIR/agent.py"; chmod 644 "$DIR/panel.html"
python3 -m py_compile "$DIR/agent.py"

NEWTOKEN=""
if [ ! -f "$DIR/agent.json" ] || [ "${ROTATE:-0}" = "1" ]; then
  NEWTOKEN="$(python3 -c 'import secrets;print(secrets.token_urlsafe(32))')"
  HASH="$(printf %s "$NEWTOKEN" | sha256sum | cut -d' ' -f1)"
  CERT=/etc/xray/xray.crt; KEY=/etc/xray/xray.key
  cat > "$DIR/agent.json" <<EOF
{"token_sha256":"$HASH","port":$PORT,"cert":"$CERT","key":"$KEY"}
EOF
  chmod 600 "$DIR/agent.json"
fi

cat > /etc/systemd/system/babayaga-agent.service <<EOF
[Unit]
Description=BABAYAGA VPS agent
After=network-online.target xray.service

[Service]
ExecStart=/usr/bin/python3 $DIR/agent.py
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable babayaga-agent >/dev/null 2>&1
systemctl restart babayaga-agent
sleep 2
if ! systemctl is-active --quiet babayaga-agent; then
  echo "Agent failed to start. Logs:"; journalctl -u babayaga-agent -n 20 --no-pager; exit 1
fi

DOMAIN="$(cat /etc/xray/domain 2>/dev/null || hostname -I | awk '{print $1}')"
PORT_NOW="$(python3 -c "import json;print(json.load(open('$DIR/agent.json'))['port'])")"
echo
echo "================ BABAYAGA agent is running ================"
echo "URL   : https://$DOMAIN:$PORT_NOW"
if [ -n "$NEWTOKEN" ]; then
  echo "TOKEN : $NEWTOKEN"
  echo "(Save the token now. It is shown only once.)"
else
  echo "TOKEN : (unchanged. Run with ROTATE=1 to create a new one)"
fi
echo "Open TCP port $PORT_NOW in your Alibaba Cloud security group."
echo "==========================================================="
