# Code graph

1. Use the code graph when the project has one
   - A project has a code graph when `graphify-out/graph.json` exists at the repo root
   - Run `graphify` commands from the repo root: the commands read `graphify-out/graph.json` from the current folder
   - No `graphify-out/graph.json`: search with grep as usual and skip the rest of this rule

2. Start from a named symbol, not a question
   - Name a symbol by its file and its name: `"path/to/file.ts::SymbolName"`
   - `graphify explain "<file>::<symbol>"` lists what the symbol imports, calls and references, and what imports, calls and references the symbol
   - `graphify affected "<file>::<symbol>"` lists everything that depends on the symbol, two levels up, test files included
     - Run `graphify affected` before changing a function, a type or a module
   - `graphify path "<A>" "<B>"` finds the chain of edges between two symbols
   - Use `graphify query "<question>"` only when no symbol name is known yet
     - The query matches keywords across the whole repo, so expect unrelated hits

3. Read the exit code
   - 0: an answer
   - 3: the name matches several symbols; retry with one of the `<file>::<symbol>` forms the output lists
   - 4: no symbol matches; check the spelling, then fall back to grep

4. Grep where the graph is blind
   - Grep for exact text: error messages, config keys, string literals
   - The graph only records imports, calls and references written in the source
     - A link through an event bus, a query bus, a dependency-injection registry or any other dynamic dispatch has no edge
   - An empty `graphify path` or a short `graphify affected` list doesn't prove two things are unconnected
     - Grep the wiring before saying two things are unconnected

5. Treat a graph answer as a lead, not a fact
   - Open the file and line the graph names before claiming anything about the code
   - The graph shows the code as it was at the last build, so read edits made since then from disk

6. Keep the graph fresh
   - A SessionStart hook runs `graphify update .` when each session starts
   - When I pull or switch branches mid-session, the main conversation runs `graphify update .` before starting the next subagent
   - Subagents never run `graphify update` or `graphify extract`, so only one process writes the graph at a time
   - When a graph answer doesn't match the file on disk, say in your output that the code graph looks stale
