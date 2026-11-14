---
name: mermaid-diagrams
description: "Use when drawing, editing or reviewing a Mermaid diagram in ./doc or ./ignored markdown. The skill covers when a diagram earns its place, picking the type, labels, size, syntax traps and checking the diagram against the code. The skill is not for data charts or Artifact pages."
---

# Scope

These rules cover every Mermaid diagram in this repo's markdown: convention pages
in `doc/`, and diagnoses and feature notes in `ignored/`. GitLab renders the
`doc/` pages. The `ignored/` files are never committed, so readers only ever see
the `ignored/` files locally. Every renderer applies its own light or dark theme.

The agent or page you are writing for adds rules on top of these: how many
diagrams, when to draw, how to tag them. Where an agent's rule and a rule here
disagree, the stricter rule wins.

# When to draw

Draw a diagram when the reader would otherwise have to hold several places,
actors or states in their head at once. First ask whether a reader would learn
more from the diagram than from a well-written paragraph. If the answer is no,
write the paragraph.

- Show one idea per diagram, at one level of abstraction. A request flow and a
  storage layout are two diagrams.
- Use a markdown table for a taxonomy, a matrix or a list of options. A table
  stays readable in a narrow column; a wide tree doesn't.
- Never draw a two-box diagram. A sentence says the same thing in less space.
- To show a change, draw before and after with the same node IDs and labels, so
  the only thing that differs between the two diagrams is the change.
- Put the diagram right after the prose that introduces the diagram, in a fenced
  ```mermaid block. Follow the diagram with one line on what the reader should
  take from the diagram.

# Choosing the type

| The diagram answers | Type |
| --- | --- |
| Where does data live, and how does the data move? | `flowchart` |
| What happened first, across which actors? | `sequenceDiagram` |
| Which states exist, and which transitions are legal? | `stateDiagram-v2` |
| How do Supabase tables relate? | `erDiagram` |

Stick to these four types. Renderers bundle different Mermaid versions, and the
beta types (`architecture-beta`, `block-beta`, C4) and the v11 `@{ shape: … }`
syntax may not render in all of them.

- A sequence diagram shows interactions between components, not the steps of one
  algorithm. Start with the happy path, then add only the branch the document is
  about.
- A state diagram holds states and transitions, nothing else. Label each
  transition with the event that triggers the transition. A state is a mode, such
  as open or closed, never a data value such as a balance.
- An ER diagram shows the tables and relationships the document discusses, not
  the whole schema.

# Content

**A diagram is a claim.** Verify every node and every edge against the code,
exactly as you would a sentence.

- Name real things: modules, handlers, stores, contracts and tables a reader
  could grep for. Never draw a generic box labelled "Frontend" or "Backend".
- Use one name per thing across the diagram and the prose. If the prose says
  `BackgroundDeviceKeyService`, the node says `BackgroundDeviceKeyService`, not
  "key service".
- Label every edge with what flows across the edge: "dispatch LoadDeviceKey",
  "status as JSON". A bare arrow teaches nothing, and neither does a label that
  only repeats the target's name.
- Draw the architecture the code has. Components dispatch events and read
  through queries, so an edge from a component straight to a Zustand store is a
  false claim.
- Name the chain when a flow differs by chain. One generic "wallet" box hides the
  difference between EVM, Solana and Bitcoin.
- Never invent an edge, an order or a cardinality to make a diagram look
  complete. Leave the gap, and say in the prose what is unknown.

# Size and layout

- Keep a diagram under about a dozen nodes. The count includes participants in a
  sequence diagram and states in a state diagram. Split rather than crowd.
- Cut edges before nodes. Too many edges make a flowchart unreadable long before
  too many nodes do. Keep only the edges the diagram's point needs.
- Keep node labels to two to four words. Put a role on a second line with
  `<br/>`, and put anything longer in the prose.
- Keep the diagram narrow. Rendered markdown sits in a narrow column, and a wide
  diagram shrinks until the labels are unreadable. Use `flowchart LR` for a short
  chain and `flowchart TB` once the longest path passes about five nodes.
- Use at most one level of `subgraph` or `box`, and only when the grouping is the
  point: a runtime, a process boundary, a repo.

# Notation

Diagrams in `ignored/` already share this notation. Keep to the notation so every
diagram reads the same way.

Nodes:

- `Svc["BackgroundDeviceKeyService"]` — a module, handler, service or screen
- `worker["Background worker<br/>back-end"]` — the same, with a role on a second
  line
- `Store[("deviceKeyPanelStore")]` — storage: a Zustand store, `chrome.storage`,
  a table
- `user([User])` — a person
- `H{"same address?"}` — a decision

Edges:

- `-->|"dispatch LoadDeviceKey"|` — a call, or data flowing
- `-.->|"asked for"|` — proposed, or not built yet. Say in the line under the
  diagram which edges are dotted and why.
- `<-->|"reads and writes"|` — a two-way exchange

Sequence diagrams:

- Group participants by runtime with `box`: side panel, background worker,
  contract, server.
- Give every participant a short alias and its real name:
  `participant H as LoadDeviceKey handler`.
- Use `->>` for a call and `-->>` for the reply.
- Use `Note over` for a guard or check that changes the outcome, such as a sender
  check.

Never set themes, colours or styles: no `%%{init}%%`, `classDef`, `style` or
`linkStyle`. A fill picked for the light theme is unreadable in the dark theme.
Carry meaning with shape and line style, never with colour alone.

# Syntax traps

A syntax error only shows when someone opens the rendered page.

- Quote every label. Punctuation, slashes and symbols need quotes, and quoting
  every label removes the guesswork: `A["vault (v1)"]`, `-->|"yes, today"|`.
- Never write a lowercase `end` as a node ID. A lowercase `end` closes a subgraph
  or block early. Write `Done["end"]`, and in a sequence message wrap the word in
  quotes or brackets.
- Never start a node ID with a lowercase `o` or `x` right after an arrow.
  `A-->oB` draws a circle-ended edge to `B`, not an edge to `oB`.
- Keep node IDs short and distinct from labels and from subgraph IDs.
- In a sequence message, a semicolon ends the message. Write `#59;` for a literal
  semicolon.
- Write `#quot;` for a double quote inside a quoted label.
- Put `%%` comments on their own line.
- Declare the diagram type on the first line of the block.

For a case these traps don't cover, fetch the syntax page for the diagram type
with `WebFetch`, and ask for the exact syntax verbatim rather than a summary:

- https://mermaid.js.org/syntax/flowchart.html
- https://mermaid.js.org/syntax/sequenceDiagram.html
- https://mermaid.js.org/syntax/stateDiagram.html
- https://mermaid.js.org/syntax/entityRelationshipDiagram.html

The pages describe the latest release. Don't use a feature the pages mark as
new or beta, because GitLab may bundle an older Mermaid version.

# Verification

Run these checks before handing a diagram over, and run the same checks when
reviewing a diagram.

1. Grep for every node name. A node missing from the code is either proposed,
   drawn with dotted edges and labelled as proposed, or wrong.
2. Check every edge against the call, import, message or store write the edge
   claims. Direction matters: who calls whom, who writes which store.
3. Erase each node and edge in turn. Delete anything whose loss the reader would
   not notice.
4. Read the diagram against the prose beside the diagram. Where the diagram and
   the prose disagree, find out which one is wrong.
5. Read the source against the syntax traps above.
