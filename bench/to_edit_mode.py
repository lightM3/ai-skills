"""Turn a read-only mobil-android eval case into its edit-mode variant (see build-android-h2h.sh).

usage: python3 -I to_edit_mode.py <case dir> <skill-name regex for the skill-fired check>

Edit mode: the agent may write files and use the web, so skills whose workflow is "act, look up,
then change the project" are not handicapped. It must end by pasting the final contents of every
file it changed; the original graders then score that final message unchanged.
(Edit is left out: `claude plugin eval` runs in don't-ask mode and denied Edit even when granted,
while Write worked — so agents use Write.)
"""
import pathlib
import re
import sys

case = pathlib.Path(sys.argv[1])
skill_re = sys.argv[2]
graders = case / "graders"

p = case / "prompt.md"
text = p.read_text()
fm_end = text.index("\n---", 4)
fm, body = text[:fm_end], text[fm_end:]
fm = re.sub(r"allowed_tools:\s*\[[^\]]*\]",
            "allowed_tools: [Read, Glob, Grep, Write, WebFetch, WebSearch, Skill]", fm)
fm = re.sub(r"max_turns:\s*\d+", "max_turns: 40", fm)
fm = re.sub(r"tags:\s*\[[^\]]*\]", "tags: [h2h-edit]", fm)
body = re.sub(r"\s*(Show every changed file( in full)?|Show the (full updated|changed) (files?|code))\.?", "", body)
body = body.rstrip() + (
    "\n\nMake the changes directly in the project files. When you're done, reply with the full final"
    " contents of every file you changed, and explain what you changed and why.\n"
)
p.write_text(fm + body)

for g in graders.glob("*.md"):
    t = g.read_text()
    if g.name.startswith("skill-fired"):
        g.unlink()
        continue
    t = t.replace("; it doesn't matter that the agent could not write files", "")
    t = t.replace(" it doesn't matter that the agent could not write files.", "")
    g.write_text(t)

(graders / "skill-fired.md").write_text(
    "---\ntype: tool_used\ntool: Skill\n"
    f"input_match: '\"skill\"\\s*:\\s*\"(?:[\\w-]+:)?({skill_re})\"'\n---\n"
)
