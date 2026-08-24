---
layout: about
title: about
permalink: /
# TODO: replace with your real title, e.g. PhD Student, GRASP Lab, University of Pennsylvania
subtitle: University of Pennsylvania

profile:
  align: right
  image: prof_pic.jpg
  image_circular: true # crops the image to make it circular
  more_info: >
    <p>University of Pennsylvania</p>
    <p>Philadelphia, PA</p>

selected_papers: true # lists papers.bib entries marked selected={true}
social: true # includes social icons at the bottom of the page

announcements:
  enabled: true # includes a list of news items
  scrollable: true # adds a vertical scroll bar if there are more than 3 news items
  limit: 5 # leave blank to include all the news in the `_news` folder

latest_posts:
  enabled: false # flip to true once you actually write blog posts
  scrollable: true
  limit: 3
---

I work on **reinforcement learning for legged robots**, and on making learned
controllers safe enough to run around other robots and other people.

<!-- TODO: one sentence on your position and advisor, e.g.
     "I am a second-year PhD student at the University of Pennsylvania, advised by Prof. X." -->

My current research asks what happens when safety and competition are put in the
same problem. The usual answer is a penalty term: a controller is paid to win and
fined when it crashes, and the two are traded off inside one reward. I take a
different route — encode the safety rule as a _filter_ around the policy, so it
reshapes the space of admissible strategies instead of the score. Under a
least-restrictive filter the rule is never actually triggered in play, and the
competitive equilibrium of the game is preserved exactly: safety costs no
competitive value. I build this out on two quadrupeds playing a zero-sum
dogfight, where the safety specification is coupled — whether one robot can stay
safe depends on what the other does — and verify it in hardware on Unitree Go2s.

Along the way I care about the unglamorous parts: reachability-based certificates
that survive contact, self-play that does not collapse, domain randomisation that
holds up on a real sensor channel, and exploitability as the honest measure of a
policy rather than its win rate against a fixed opponent.

<!-- TODO: a line about your background, or delete this block.
     e.g. "Before Penn I did X at Y." -->
