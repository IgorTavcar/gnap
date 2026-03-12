# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

GNAP (Git-Native Agent Protocol) — a specification and tooling for coordinating AI agent teams using git as the only transport/storage layer. No server required.

**Status:** Draft v3, March 2026. This is a protocol spec repo, not a traditional software project.

## Two-Layer Architecture

```
GNAL (Application Layer)  — workflows, playbooks, policies, events, knowledge
GNAP (Protocol Layer)     — 4 entities: Agent, Task, Run, Message
Git  (Transport)          — push/pull/commit = the message bus
```

- **Protocol (GNAP core):** Defined in `README.md`. Four JSON entities live in `.gnap/` — `agents.json`, `tasks/*.json`, `runs/*.json`, `messages/*.json`. These are the atoms every agent must understand.
- **Application layer (GNAL):** Defined in `APPLICATION.md`. Markdown-based business logic in `app/` — workflows, playbooks, policies, templates, events, knowledge. Optional but recommended.
- **Agent communication (kanban):** Defined in `AGENTS-PROTOCOL.md`. Describes how agents read/write `kanban-data.json` via GitHub Contents API with SHA-based optimistic locking.

## Key Files

| File | Purpose |
|------|---------|
| `README.md` | GNAP protocol spec — the 4 entities, schemas, state machines, transport |
| `APPLICATION.md` | GNAL companion spec — workflows, playbooks, policies, events, knowledge |
| `AGENTS-PROTOCOL.md` | Agent communication protocol for the farol.team kanban |
| `ONBOARDING.md` | How to invite and onboard a new agent to an HQ |
| `gnap.sh` | CLI tool for kanban operations (read, create, move, update, block) |
| `examples/` | Reference data: `.gnap/` (org, company, budget, tasks, runs, messages) and `app/` (workflows, playbooks, policies, events) |

## CLI Tool

`gnap.sh` operates on `kanban-data.json` via GitHub API. Requires `GNAP_GITHUB_TOKEN` env var for writes.

```bash
./gnap.sh read                              # Read all tasks (JSON)
./gnap.sh my-tasks <agent-id>               # List tasks for agent
./gnap.sh create <agent> <slug> <title> <tag> [col] [desc]
./gnap.sh move <card-id> <column> <agent>
./gnap.sh update <card-id> <field> <value> <agent>
./gnap.sh block <card-id> <reason> <agent>
```

## Core Protocol Concepts

**Task states:** `backlog → ready → in_progress → review → done` (also `blocked`, `cancelled`). Reverse transitions: `review → in_progress` (reject), `blocked → ready` (unblocked).

**Commit convention:** `<agent-id>: <action> <entity> [details]` — git history IS the audit log.

**Heartbeat loop:** Each agent polls on `heartbeat_sec` interval: pull → check status → check tasks → check messages → work → commit → push.

**Conflict resolution:** SHA-based optimistic locking. On conflict: re-read, re-apply, retry (max 3).

## Editing Guidelines

- This is a spec repo. Changes to `README.md` or `APPLICATION.md` change the protocol/application-layer definition.
- JSON schemas in the spec docs are normative — keep entity examples consistent across all docs.
- The four GNAP entities (Agent, Task, Run, Message) are intentionally minimal. Resist adding new protocol-level entities.
- `examples/` should always be valid instances of the schemas defined in the specs.
- `workflow.md` in `.gnap/` uses `{{mustache}}` template syntax for agent prompt interpolation.
