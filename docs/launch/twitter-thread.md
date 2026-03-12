# Twitter/X Thread

---

**Tweet 1 (hook):**

We replaced our agent orchestration server with 4 JSON files in a git repo.

No server. No database. No vendor lock-in.

Here's how we coordinate 5+ AI agents with just git push/pull:

🧵

---

**Tweet 2 (problem):**

The problem: we run AI agents on different machines — OpenClaw, Claude Code, Codex.

They need to:
- Share tasks
- Track who's doing what
- Communicate
- Not do duplicate work

Every existing tool (Paperclip, Symphony, CrewAI) requires a running server.

---

**Tweet 3 (solution):**

Our solution: GNAP (Git-Native Agent Protocol)

4 entities, all JSON files in `.gnap/`:

```
agents.json     → the team
tasks/FA-1.json → work items
runs/FA-1-1.json → execution attempts
messages/1.json → communication
```

That's the entire protocol.

---

**Tweet 4 (how it works):**

Every agent runs a heartbeat loop:

1. git pull
2. Check: am I active?
3. Check: any tasks assigned to me?
4. Check: any messages for me?
5. Do the work
6. git commit && git push
7. Sleep

Git history = audit log. No separate database.

---

**Tweet 5 (comparison):**

How GNAP compares:

| | Server | Database |
|---|---|---|
| GNAP | None | None (git) |
| AgentHub | Go binary | SQLite |
| Paperclip | Node.js | PostgreSQL |
| Symphony | Process | In-memory |
| CrewAI | Python | In-memory |

---

**Tweet 6 (quickstart):**

Set up a GNAP team in 30 seconds:

```bash
mkdir my-team && cd my-team && git init
mkdir -p .gnap/tasks .gnap/runs .gnap/messages
echo '4' > .gnap/version
echo '{"agents":[...]}' > .gnap/agents.json
```

Done. Your agents can now coordinate.

---

**Tweet 7 (key insight):**

The key insight:

Git already gives you everything an agent orchestrator needs:
- Versioning
- Audit trail
- Distribution
- Conflict resolution
- Authentication
- Works offline

We just defined 4 JSON schemas on top.

---

**Tweet 8 (CTA):**

GNAP is MIT licensed and open source.

Any agent that can `git push` can participate — no vendor lock-in.

GitHub: https://github.com/farol-team/gnap

Star it if you think agents should coordinate without servers.

---

**Optional tag tweet:**

cc @kaborya @OpenAI — we compared GNAP to AgentHub and Symphony in the README. Would love your thoughts on the serverless approach.
