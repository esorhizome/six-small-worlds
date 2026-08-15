# Fun-ishment — a field guide to the pressure machine

*Most games you have played this decade contain machinery whose purpose is to
punish you for leaving. This page names that machinery, so you can recognise
it — in the games you play, and in the games you are about to build.*

## Why this page is in a maths classroom

Every lesson in this repo teaches a rule that makes something grow: a colony,
a root, a school of fish, a difficulty dial. Rules are levers, and a lever
does not care which way it is pulled. The same exponential that fades
sunlight in [World 5](../05-friendly-waters/) can price an upgrade ladder
that quietly demands a decade. The same Poisson clock that fills a guestbook
in [World 3](../03-tidepool-keeper/) can schedule a reward drip tuned to
keep you checking your phone at dinner.

So before you build with these levers, you should see both grips. This
studio's six games hold them one way — deliberately, and against the current
fashion. You will hold them however you choose; our contract with you is
recognition, not obedience.

**Fun-ishment** is our house word for the fashionable grip: mechanics that
feel like play but operate as punishment — where the engine of engagement is
the *avoidance of loss* rather than the presence of joy. Players sometimes
call the milder forms "chores"; researchers file the sharper forms under
dark patterns. It works. That is the uncomfortable part: it works very well,
and on all of us.

## The patterns, named

You have felt every one of these. Now they have names.

| Pattern | Where you've felt it | The lever it pulls |
|---|---|---|
| **Login streak** | "You're on a 47-day streak!" — and the dread of day 48 | Loss aversion: after a week, the streak is a possession, and losing a possession hurts roughly twice as much as gaining one pleases (Kahneman & Tversky, 1979) |
| **Decay & expiry** | Crops wither; the pet is sad; your rank decays each season | Turns absence into damage. The game stops being a place you visit and becomes a place you *owe* |
| **Appointment mechanics** | "Come back in 4 hours" — and the bonus if you do, gone if you don't | Schedules your day around the game's clock instead of the game around yours |
| **Energy systems** | Five lives; the sixth costs money or a wait | Sells you back the right to keep playing — interruption as a product |
| **FOMO timers** | "Event ends in 02:13:44"; the battle-pass season; the daily shop | Manufactures scarcity in a medium with none. Every purchase is framed as a rescue from missing out |
| **The escalating drip** | Rewards on a variable schedule, rarest right when you'd quit | Variable-ratio reinforcement, the schedule that resists extinction best (Skinner, 1953) — the slot-machine's timing, wearing a quest log |
| **Punitive difficulty spikes** | A wall placed exactly where the booster pack is sold | Difficulty as a sales channel rather than a conversation with your skill |
| **Sunk-cost architecture** | "You've already invested 200 hours…" displayed as a badge | Reframes leaving as wasting yourself |

The academic study of several of these began with Zagal, Björk & Lewis,
"Dark Patterns in the Design of Games" (FDG 2013) — a short, readable paper,
and the polite academic voice makes the catalogue land harder.

None of these patterns is bad *mathematics*. Every one is a competent use of
a real result about how animals — including us — respond to schedules of
reward and threat of loss. The objection is not technical. It is that the
player's fear is doing work the design should be doing.

## The same levers, held the other way

Here is the deliberate contrast, world by world. Same mathematics, opposite
grip — this is what these six games are doing differently, and now you have
the vocabulary to see it:

| World | The fun-ishment grip | This studio's grip |
|---|---|---|
| [equanim](../01-equanim/) | A gallery with a daily-visit badge and a completion meter shaming the gaps | No meters, no streaks, nothing expires. Cards turn whether you watch or not — you are a guest, not a debtor |
| [upgrade Biotech](../02-upgrade-biotech/) | Idle-genre standard: offline earnings capped so you log in; prestige resets sized to sunk cost | The anti-chore contract: no offline cap, no daily anything. The exponential prices curiosity, never ransom |
| [Tidepool Keeper](../03-tidepool-keeper/) | A pet that suffers when you leave — decay as a leash | The Poisson guestbook: absence *accrues* visits. A month away returns a month of stories, uncapped. The tide clock schedules the water, never you |
| [An Isolate Grows Roots](../04-an-isolate-grows-roots/) | Timed growth you can pay to skip — patience as a paywall | One turn per deliberate tap; a mid-turn tap is refused with a ring, not a rebuke. Patience is the *content*, so there is nothing to sell past |
| [Friendly Waters](../05-friendly-waters/) | Oxygen meters, drowning timers, depth as threat | Light as a resource you can see and always resurface from. The deep is dark because water is honest, not because the game wants you afraid |
| [EXTR, run!](../06-extr-run/) | Rubber-band difficulty that spikes to sell revives; "one more run" tuned by frustration | The comfort ramp: difficulty advances only after unhurt runs, retreats after rough ones, and the reaction-time budget (~250 ms + device margin) is a floor no dial position may cross |

Read the right-hand column again and notice it is not "no mathematics". It
is *more* mathematics — a fairness floor is a derived quantity; an uncapped
guestbook needs a distribution you trust; a comfort ramp is a logistic
curve with its ambition removed. Kindness, engineered, is still engineering.

## For your own game

When you build (see [Build Your Own World](build-your-own.md)), run this
three-question check on any retention idea:

1. **Does it reward presence, or punish absence?** The same feature can often
   be flipped: a streak that *pauses* instead of breaking rewards presence; a
   streak that shatters punishes absence.
2. **Who owns the clock?** If the player sets the pace, it's a game. If the
   game sets the player's calendar, it's a shift rota.
3. **Would it survive being explained?** "The rare drop is on a
   variable-ratio schedule tuned to your quit probability" does not survive.
   "Creatures visit while you're away, and more time means more visitors"
   survives being printed on the box — it *is* printed on ours.

Players increasingly know the pressure machine when they feel it. Building
without it is not a handicap; it is a difference a store page can say out
loud. And self-determination theory has long suggested the durable pull of
games comes from competence and autonomy, not compulsion (Ryan, Rigby &
Przybylski, 2006) — the machine is not even load-bearing.

## Sources

- **Primary:** D. Kahneman & A. Tversky, "Prospect Theory: An Analysis of
  Decision under Risk", *Econometrica* 47(2), 1979. Loss aversion — losses
  loom larger than gains.
- **Primary:** B. F. Skinner, *Science and Human Behavior*, Macmillan, 1953.
  Schedules of reinforcement; variable-ratio's resistance to extinction.
  (Free to read at the B. F. Skinner Foundation, bfskinner.org.)
- **Primary:** J. P. Zagal, S. Björk & C. Lewis, "Dark Patterns in the Design
  of Games", *Foundations of Digital Games*, 2013. The founding catalogue of
  the field; the PDF circulates freely from the authors' pages.
- **Primary:** R. M. Ryan, C. S. Rigby & A. Przybylski, "The Motivational
  Pull of Video Games: A Self-Determination Theory Approach", *Motivation and
  Emotion* 30, 2006. Competence and autonomy predict sustained play.
- **Secondary (free):** Harry Brignull's pattern library at
  [deceptive.design](https://www.deceptive.design) — the general-purpose dark
  patterns catalogue the games literature grew alongside.
- **Secondary (free):** J. Chen, "Flow in Games", MFA thesis, USC, 2006 —
  free at jenovachen.com; the difficulty-as-comfort lineage World 6 builds on.
