# User Story Splitting Patterns

Reference based on the Humanizing Work guide to splitting user stories.

---

## 1. What Makes a Good User Story

A user story is **a description of a change in system behavior from the perspective of a user**.

Every story must answer three questions:
1. **Who** is it for?
2. **What** do they want to do?
3. **Why** — what value does it deliver?

The template `"As a [role], I want [action], so that [value]"` is useful scaffolding, but the format isn't what matters — the three questions are. A story written in plain prose that answers all three is better than a rote template that obscures them.

> **Warning:** `"As a developer, I want X"` is almost always a task pretending to be a story. Developer-facing work belongs in a story's acceptance criteria or in a technical task, not as a standalone user story.

---

## 2. INVEST Criteria

| Criterion | Meaning |
|-----------|---------|
| **Independent** | Self-contained enough to be prioritized by value, not forced into a sequence by technical dependency. Sometimes this means building scaffolding so a story can be tested on its own. |
| **Negotiable** | Leaves room for collaboration on the details of *what* and *how*. A story is a conversation starter, not a contract. |
| **Valuable** | Every story adds visible value for users. This is the hardest and most important criterion. |
| **Estimable** | Defined enough to estimate relative size. If the team cannot estimate, that's a signal for a [Spike](#9-break-out-a-spike). |
| **Small** | Completable within a single sprint. Rule of thumb: 6–10 stories should fit in a sprint by the time they reach the top of the backlog. |
| **Testable** | Describes a concrete change in system behavior, not a vague aspiration. |

### Tension between criteria

As stories get smaller, it becomes harder to keep them **Independent** and **Valuable**. That's okay — different attributes matter at different times:

- **Near sprint planning:** Small, Estimable, Testable matter most.
- **Further out in the backlog:** Independent, Negotiable, Valuable matter most.

Don't force every criterion to full strength at every stage.

---

## 3. Vertical Slices

A **vertical slice** delivers a valuable change in system behavior that touches multiple architectural layers (UI → business logic → data layer → external integrations).

A **horizontal slice** delivers one layer or component — a UI without a backend, or a schema without any business logic. Horizontal slices need to be combined with other horizontal slices before they provide value.

### Why this matters

| Horizontal slices | Vertical slices |
|-------------------|-----------------|
| Each piece alone has no user value | Each piece can be used/tested by a real user |
| Value only visible at end of project | Value visible and verifiable during development |
| Hard to reprioritize mid-stream | Easy to reprioritize or drop low-value slices |
| Feedback comes late | Feedback comes early |

**Anti-pattern:** Splitting by architectural layer (one story for the API, one for the DB schema, one for the UI). This satisfies **Small** but fails **Independent** and **Valuable**.

Teams working in vertical slices make value explicit, get earlier feedback, and become more predictable.

---

## 4. The Splitting Flowchart

### Step 1 — Validate the input

Before splitting, ask: does the story satisfy INVEST (except Small)?

- **If it's a task or component** masquerading as a story, combine it with related pieces until it represents a genuine increment of user value.
- **If it's not too big**, don't split it — stop here.
- **If it is too big**, proceed to Step 2.

### Step 2 — Apply patterns

Try multiple patterns, not just the first one that fits. Different patterns reveal different possible splits; comparing them leads to better choices.

See [Section 5](#5-the-nine-patterns) for all nine patterns with examples.

### Step 3 — Evaluate the split

Two rules of thumb for choosing between candidate splits:

1. **Choose the split that lets you deprioritize or throw away a story.** The best splits reveal low-value functionality that doesn't need to be built at all.
2. **Choose the split that produces more equally-sized stories.** More equally-sized pieces give the Product Owner more freedom to reprioritize.

---

## 5. The Nine Patterns

### 1. Workflow Steps

Split along steps in a business process.

**Don't** decompose one step at a time from beginning to end (that produces horizontal slices of the workflow). **Do** build a simple end-to-end path first, then add intermediate steps.

> **Before:** Publish a news story *(too big)*
>
> **After:**
> - **Publish a news story directly** (author publishes immediately) ← *start here: simplest end-to-end path*
> - Publish a news story with editor review
> - Publish a news story with legal review

---

### 2. Operations (CRUD)

The word "manage" is a reliable signal. Break it into individual operations.

> **Before:** Manage my account *(too big)*
>
> **After:**
> - Sign up for an account
> - Edit account settings
> - Cancel my account

---

### 3. Business Rule Variations

Different rules that apply to the same action. Each rule is its own story.

> **Before:** Search for flights with flexible dates *(too big)*
>
> **After:**
> - Search with a range of *n* days between date *x* and date *y*
> - Search for a weekend in a given month
> - Search ±*n* days from a target date

---

### 4. Variations in Data

Complexity comes from handling different data shapes or sources. Start with the simplest "good enough" version; add variations just-in-time.

> **Before:** Search for hotels by geographic area *(too big)*
>
> **After:**
> - Search by county (simplest geographic unit)
> - Search by city (given county works)
> - Search by neighborhood (given city works)

---

### 5. Data Entry Methods

Complexity lives in the UI, not in the functionality. Separate the simple interaction from the polished one.

> **Before:** Search for flights *(too complex UI)*
>
> **After:**
> - Search for flights using plain text date entry
> - Search for flights using a graphical calendar picker

---

### 6. Major Effort

The first implementation of a thing is most of the work; subsequent variations are cheap once the first is done. Defer the decision about which variation goes first — let the Product Owner choose the highest-value one.

> **Before:** Pay with VISA, Mastercard, Discover, or Amex *(too big)*
>
> **After:**
> - Pay with one card type *(most effort — picks the approach)*
> - Pay with all four card types *(trivial, given one is implemented)*

---

### 7. Simple/Complex

Ask: *"What's the simplest version of this story?"* Capture that core as its own story. Promote each variation to its own story.

> **Before:** Search for flights *(too big, too many variations baked in)*
>
> **After:**
> - Search for flights *(simple: origin, destination, date)*
> - Search for flights specifying max number of stops
> - Search for flights including nearby airports
> - Search for flights with flexible dates

---

### 8. Defer Performance

"Make it work" first, then "make it fast." This extends to other non-functional requirements like scalability or accessibility. **Be cautious with security** — deferring security creates exploitable vulnerabilities, not just technical debt. Security deferrals carry categorically different risk and should require explicit team agreement and a short timeline.

> **Warning:** Don't use this to permanently defer quality. Technical debt accumulates; track these stories and prioritize them before they become emergencies.

> **Before:** Search for flights (must return results in under 5 seconds) *(too complex to do in one slice)*
>
> **After:**
> - Search for flights (slow, with loading animation to manage user expectation)
> - Search for flights (results in under 5 seconds)

---

### 9. Break Out a Spike

**Last resort** — use when the implementation is poorly understood and you can't estimate. A spike is a **time-boxed investigation**; the acceptance criteria are the questions to be answered, not working software.

> - Stop when you have answers; don't build the thing during the spike.
> - The spike produces knowledge; the follow-on story uses that knowledge to build.

> **Before:** Pay by credit card *(team has no idea how to approach it)*
>
> **After:**
> - **Spike:** Investigate credit card processing options — what APIs are available, what does PCI compliance require, what's the estimated effort? *(time-boxed: 2 days)*
> - Implement credit card payment *(estimated after spike)*

---

## 6. Meta-Pattern: Find the Complexity & Reduce the Variations

When no single pattern feels right, use this three-step meta-pattern:

1. **Find the core complexity** — What's most likely to surprise you? Core complexity often lives in things that depend on human behavior, preferences, or external systems.
2. **Identify the variations** — Business rules, user types, interfaces, data variations, entities.
3. **Reduce all variations to one** — Find a single, complete vertical slice through the complex part, with every other variation stripped away.

This is especially powerful for the **first slice of something new** because it goes straight to the hard part and avoids all the noise. Once you've navigated the core complexity, the variations become much easier to estimate and prioritize.

> **Example:** Building a complex pricing engine with multiple customer tiers, currencies, and discount rules. Don't add all the rules at once. Find the hardest rule, build end-to-end for one customer type / one currency / no discounts, then add variations.

---

## 7. Cynefin and Story Splitting

Story splitting looks different depending on where you are in the [Cynefin framework](https://en.wikipedia.org/wiki/Cynefin_framework):

| Domain | Approach |
|--------|----------|
| **Obvious** | Just build it. If too big, find all the stories and do the most valuable ones first. |
| **Complicated** | Find all the stories; do the most valuable *and* most risky ones first. |
| **Complex** | **Don't try to find all stories.** Find 1–2 that provide value and teach you about the problem. Starting the work is how you learn about the work. Enumerating all stories upfront is an illusion of predictability. |
| **Chaotic** | Put out the fire. Story splitting is probably not important right now. |
| **Disordered** | Figure out which domain you're in first before doing anything else. |

The biggest mistake teams make in the **Complex** domain is spending effort on exhaustive backlog decomposition to create a false sense of control. The work will tell you what it needs.

---

## 8. Common Anti-Patterns

| Anti-pattern | Problem |
|--------------|---------|
| `"As a developer, I want..."` | A task masquerading as a story — no user value visible |
| Splitting by architectural layer | Produces horizontal slices; each piece fails Independent and Valuable |
| Technical dependency chains | Stories only "work" in a forced sequence; violates Independent |
| Stories only valuable in combination | No single story can be demoed, tested, or shipped independently |
| Using "spike" for any uncertain work | Spikes are last resort; most uncertainty resolves through patterns 1–8 |
| Permanently deferring non-functional requirements | "Make it work then make it fast" doesn't mean NFRs are optional — track and prioritize them before they become emergencies |
| Enumerating all stories in complex domains | Creates illusion of predictability; the work will invalidate assumptions |
