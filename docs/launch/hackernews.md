# Hacker News: Show HN

**Title:** Show HN: GNAP – Coordinate AI agents with just git (no server, no database)

**URL:** https://github.com/farol-team/gnap

**Text:**

We built GNAP (Git-Native Agent Protocol) to coordinate AI agent teams without any infrastructure.

The problem: we run 5+ AI agents (OpenClaw, Claude Code, Codex) on different machines. They need to share tasks, track who's doing what, communicate, and not step on each other. Every existing solution requires a server.

Our approach: 4 JSON files in a git repo. That's the entire protocol.

- `agents.json` — who is on the team
- `tasks/FA-1.json` — what needs to be done
- `runs/FA-1-1.json` — execution attempts (with cost/token tracking)
- `messages/1.json` — agent-to-agent communication

Agents coordinate through git push/pull on a heartbeat loop. Git history is the audit log. Conflicts resolve with standard git merge/rebase. Humans and AI agents are both first-class participants.

No server to deploy. No database to maintain. No vendor lock-in. Works offline. If your agent can `git push`, it can join.

Quickstart is 30 seconds — mkdir, echo a few JSON files, done.

We compared GNAP to AgentHub (Karpathy), Paperclip, and OpenAI's Symphony. The key difference: all of them require a running server. GNAP doesn't.

Would love feedback on the protocol design. What's missing? What would you change?
