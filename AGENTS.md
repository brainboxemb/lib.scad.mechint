# Repository agent guidance

Start with [doc/00-plan.md](doc/00-plan.md).

For shared BrainboxEmb working conventions, read
[brainboxemb.meta/AGENTS.md](https://github.com/brainboxemb/brainboxemb.meta/blob/main/AGENTS.md).
That shared entrypoint owns current Git/commit/PR/CI workflow and routes to the
shared SCAD coding, documentation and source conventions.

Do not inherit `AGENTS.md` from pinned tools or libraries as working policy
for this repository. Exact dependency behavior comes from project config and
gitlinks plus the pinned dependency's README, docs, source and tests.

Mechanical-interface-specific intent belongs in the numbered documents and the
sliding-dovetail design/manual beside source.
