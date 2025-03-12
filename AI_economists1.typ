// Some definitions presupposed by pandoc's typst output.
#let blockquote(body) = [
  #set text( size: 0.92em )
  #block(inset: (left: 1.5em, top: 0.2em, bottom: 0.2em))[#body]
]

#let horizontalrule = [
  #line(start: (25%,0%), end: (75%,0%))
]

#let endnote(num, contents) = [
  #stack(dir: ltr, spacing: 3pt, super[#num], contents)
]

#show terms: it => {
  it.children
    .map(child => [
      #strong[#child.term]
      #block(inset: (left: 1.5em, top: -0.4em))[#child.description]
      ])
    .join()
}

// Some quarto-specific definitions.

#show raw.where(block: true): set block(
    fill: luma(230),
    width: 100%,
    inset: 8pt,
    radius: 2pt
  )

#let block_with_new_content(old_block, new_content) = {
  let d = (:)
  let fields = old_block.fields()
  fields.remove("body")
  if fields.at("below", default: none) != none {
    // TODO: this is a hack because below is a "synthesized element"
    // according to the experts in the typst discord...
    fields.below = fields.below.amount
  }
  return block.with(..fields)(new_content)
}

#let empty(v) = {
  if type(v) == "string" {
    // two dollar signs here because we're technically inside
    // a Pandoc template :grimace:
    v.matches(regex("^\\s*$")).at(0, default: none) != none
  } else if type(v) == "content" {
    if v.at("text", default: none) != none {
      return empty(v.text)
    }
    for child in v.at("children", default: ()) {
      if not empty(child) {
        return false
      }
    }
    return true
  }

}

// Subfloats
// This is a technique that we adapted from https://github.com/tingerrr/subpar/
#let quartosubfloatcounter = counter("quartosubfloatcounter")

#let quarto_super(
  kind: str,
  caption: none,
  label: none,
  supplement: str,
  position: none,
  subrefnumbering: "1a",
  subcapnumbering: "(a)",
  body,
) = {
  context {
    let figcounter = counter(figure.where(kind: kind))
    let n-super = figcounter.get().first() + 1
    set figure.caption(position: position)
    [#figure(
      kind: kind,
      supplement: supplement,
      caption: caption,
      {
        show figure.where(kind: kind): set figure(numbering: _ => numbering(subrefnumbering, n-super, quartosubfloatcounter.get().first() + 1))
        show figure.where(kind: kind): set figure.caption(position: position)

        show figure: it => {
          let num = numbering(subcapnumbering, n-super, quartosubfloatcounter.get().first() + 1)
          show figure.caption: it => {
            num.slice(2) // I don't understand why the numbering contains output that it really shouldn't, but this fixes it shrug?
            [ ]
            it.body
          }

          quartosubfloatcounter.step()
          it
          counter(figure.where(kind: it.kind)).update(n => n - 1)
        }

        quartosubfloatcounter.update(0)
        body
      }
    )#label]
  }
}

// callout rendering
// this is a figure show rule because callouts are crossreferenceable
#show figure: it => {
  if type(it.kind) != "string" {
    return it
  }
  let kind_match = it.kind.matches(regex("^quarto-callout-(.*)")).at(0, default: none)
  if kind_match == none {
    return it
  }
  let kind = kind_match.captures.at(0, default: "other")
  kind = upper(kind.first()) + kind.slice(1)
  // now we pull apart the callout and reassemble it with the crossref name and counter

  // when we cleanup pandoc's emitted code to avoid spaces this will have to change
  let old_callout = it.body.children.at(1).body.children.at(1)
  let old_title_block = old_callout.body.children.at(0)
  let old_title = old_title_block.body.body.children.at(2)

  // TODO use custom separator if available
  let new_title = if empty(old_title) {
    [#kind #it.counter.display()]
  } else {
    [#kind #it.counter.display(): #old_title]
  }

  let new_title_block = block_with_new_content(
    old_title_block, 
    block_with_new_content(
      old_title_block.body, 
      old_title_block.body.body.children.at(0) +
      old_title_block.body.body.children.at(1) +
      new_title))

  block_with_new_content(old_callout,
    block(below: 0pt, new_title_block) +
    old_callout.body.children.at(1))
}

// 2023-10-09: #fa-icon("fa-info") is not working, so we'll eval "#fa-info()" instead
#let callout(body: [], title: "Callout", background_color: rgb("#dddddd"), icon: none, icon_color: black) = {
  block(
    breakable: false, 
    fill: background_color, 
    stroke: (paint: icon_color, thickness: 0.5pt, cap: "round"), 
    width: 100%, 
    radius: 2pt,
    block(
      inset: 1pt,
      width: 100%, 
      below: 0pt, 
      block(
        fill: background_color, 
        width: 100%, 
        inset: 8pt)[#text(icon_color, weight: 900)[#icon] #title]) +
      if(body != []){
        block(
          inset: 1pt, 
          width: 100%, 
          block(fill: white, width: 100%, inset: 8pt, body))
      }
    )
}



#let article(
  title: none,
  subtitle: none,
  authors: none,
  date: none,
  abstract: none,
  abstract-title: none,
  cols: 1,
  margin: (x: 1.25in, y: 1.25in),
  paper: "us-letter",
  lang: "en",
  region: "US",
  font: "linux libertine",
  fontsize: 11pt,
  title-size: 1.5em,
  subtitle-size: 1.25em,
  heading-family: "linux libertine",
  heading-weight: "bold",
  heading-style: "normal",
  heading-color: black,
  heading-line-height: 0.65em,
  sectionnumbering: none,
  toc: false,
  toc_title: none,
  toc_depth: none,
  toc_indent: 1.5em,
  doc,
) = {
  set page(
    paper: paper,
    margin: margin,
    numbering: "1",
  )
  set par(justify: true)
  set text(lang: lang,
           region: region,
           font: font,
           size: fontsize)
  set heading(numbering: sectionnumbering)
  if title != none {
    align(center)[#block(inset: 2em)[
      #set par(leading: heading-line-height)
      #if (heading-family != none or heading-weight != "bold" or heading-style != "normal"
           or heading-color != black or heading-decoration == "underline"
           or heading-background-color != none) {
        set text(font: heading-family, weight: heading-weight, style: heading-style, fill: heading-color)
        text(size: title-size)[#title]
        if subtitle != none {
          parbreak()
          text(size: subtitle-size)[#subtitle]
        }
      } else {
        text(weight: "bold", size: title-size)[#title]
        if subtitle != none {
          parbreak()
          text(weight: "bold", size: subtitle-size)[#subtitle]
        }
      }
    ]]
  }

  if authors != none {
    let count = authors.len()
    let ncols = calc.min(count, 3)
    grid(
      columns: (1fr,) * ncols,
      row-gutter: 1.5em,
      ..authors.map(author =>
          align(center)[
            #author.name \
            #author.affiliation \
            #author.email
          ]
      )
    )
  }

  if date != none {
    align(center)[#block(inset: 1em)[
      #date
    ]]
  }

  if abstract != none {
    block(inset: 2em)[
    #text(weight: "semibold")[#abstract-title] #h(1em) #abstract
    ]
  }

  if toc {
    let title = if toc_title == none {
      auto
    } else {
      toc_title
    }
    block(above: 0em, below: 2em)[
    #outline(
      title: toc_title,
      depth: toc_depth,
      indent: toc_indent
    );
    ]
  }

  if cols == 1 {
    doc
  } else {
    columns(cols, doc)
  }
}

#set table(
  inset: 6pt,
  stroke: none
)

#show: doc => article(
  authors: (
    ( name: [Zahid Asghar],
      affiliation: [],
      email: [] ),
    ),
  date: [2024-11-21],
  toc_title: [Table of contents],
  toc_depth: 3,
  cols: 1,
  doc,
)

== 
<section>
#block(fill: rgb(255, 255, 250, 50%))[
#set text(size: 1.1em); Always embrace the unexpected

Comfortable being uncomfortable

]
#block[
=== Embracing AI in Economics, Business and Social Sciences
<embracing-ai-in-economics-business-and-social-sciences>
Zahid Asghar, QAU

]
= AI Won’t Replace Humans — But Humans With AI Will Replace Humans Without AI
<ai-wont-replace-humans-but-humans-with-ai-will-replace-humans-without-ai>
#link("https://hbr.org/2023/08/ai-wont-replace-humans-but-humans-with-ai-will-replace-humans-without-ai")[HBR]

#horizontalrule

== What is AI?
<what-is-ai>
#strong[Artificial Intelligence (AI):]

- The broad concept where machines simulate human intelligence.

- AI allows machines to perform tasks like decision-making, speech recognition, and problem-solving.

#strong[Examples:]

- Self-driving cars
- Virtual assistants like Siri or Alexa

== What is Machine Learning (ML)?
<what-is-machine-learning-ml>
#strong[Machine Learning (ML):]

- A subset of AI that enables machines to learn from data and improve performance over time.

- ML doesn’t require explicit programming for each task.

#strong[Types of ML:]

- Supervised Learning: Uses labeled data.
- Unsupervised Learning: Finds hidden patterns in unlabeled data.
- Reinforcement Learning: Learns through rewards and penalties.

#strong[Examples:] - Netflix recommendation system - Spam filters in email

== What is Natural Language Processing (NLP)?
<what-is-natural-language-processing-nlp>
#strong[Natural Language Processing (NLP):]

- A branch of AI focused on the interaction between computers and human (natural) languages.

- Helps machines understand, interpret, and respond to human language.

#strong[Applications:] - Sentiment analysis (understanding opinions) - Chatbots and language translation tools

#strong[Examples:] - Google Translate - Virtual Assistants

== Generative AI
<generative-ai>
#strong[Generative AI:]

- A form of AI that creates new content—whether it’s text, images, music, or other media—by learning from patterns in existing data.

- Uses deep learning models such as transformers (like GPT) and GANs (Generative Adversarial Networks).

#strong[Examples:] - GPT-4o for text generation - DALL-E for creating images from text descriptions - AI-generated music or art

== Traditional AI vs.~Generative AI
<traditional-ai-vs.-generative-ai>
=== Traditional AI
<traditional-ai>
#strong[Definition:]

- Analyzes existing data to uncover patterns, trends, or insights.

#strong[Purpose:] - Understand and summarize what’s already there.

#strong[Techniques:] - Statistical analysis, clustering, classification.

#strong[Examples:] - Business reports summarizing sales performance. - Tools like Google Analytics offering insights based on historical data.

== Generative AI
<generative-ai-1>
#strong[Definition:] - Focuses on creating new content by learning from existing patterns.

#strong[Purpose:] - To generate something new—whether it’s text, art, or even videos.

#strong[Techniques:] - Deep learning models, transformers.

#strong[Examples:] - GPT generating essays, DALL-E creating new images, AI composing music.

#horizontalrule

=== Generative AI in a Nutshell
<generative-ai-in-a-nutshell>
#box(image("images/genAI1.png"))

#horizontalrule

== 
<section-1>
#box(image("images/genAI2.png"))

#horizontalrule

== 
<section-2>
#box(image("images/genAI3.png"))

#horizontalrule

== 
<section-3>
#box(image("images/genAI4.png"))

#horizontalrule

=== LLMs
<llms>
#box(image("images/LLM.webp"))

#horizontalrule

#box(image("images/LLM2.jpg"))

#horizontalrule

#box(image("images/genAI6.png"))

#horizontalrule

#box(image("images/genAI7.png"))

== Generative AI in a Nutshell
<generative-ai-in-a-nutshell-1>
#box(image("AI_economists1_files\\mediabag\\generative-AI-in-a-n.png", height: 7.2916666666667in, width: 13.260416666667in))

#table(
  columns: (100%),
  align: (left,),
  [\#\# Traditional AI vs.~Generative AI (Comparison){.scrollable}],
  [],
  [\#\# Key Takeaway],
  [- #strong[Artificial Intelligence (AI)] is the broad field enabling machines to mimic human intelligence.],
  [- #strong[Machine Learning (ML)] is a technique within AI, focused on learning from data.],
  [- #strong[NLP] allows AI to understand and interact with human language.],
  [- #strong[Generative AI] creates new, original content based on learned patterns.],
  [- #strong[Traditional AI] analyzes existing data to provide insights, while #strong[Generative AI] creates something entirely new.],
  [\#\#\# New Wave of Technology],
  [- What does the wave of technology mean for humanity?],
  [- Historical discoveries: Fire, the wheel, printing press, steel, harnessing electricity],
  [- Transformation of human civilization through technological advancements],
  [\#\#\# Advanced AI and biotechnology],
  [- Benefits: Unlock secrets of the universe , Cure diseases, Create a healthier, sustainable world],
)
=== The Dangers
<the-dangers>
- Manipulating DNA: implications for individuals and ecosystems
- Choice: Unparalleled possibilities vs.~unimaginable perils
- Exponential speed of change in technology (e.g., LLMs)

=== The Rise of AI
<the-rise-of-ai>
- Four years ago, no one believed in LLMs, now everyone talks about them

- Future: Superintelligence in the next decade?

- Question: How do we respond?

#horizontalrule

=== The Dilemma
<the-dilemma>
- Replicating our unique intelligence

- The Luddite reaction: fears, bans, moratoriums

- Challenge: balancing immense benefits and potential perils

==== The Containment Problem
<the-containment-problem>
- Technology spreads exponentially, nearly impossible to stop

- Examples: Industrial Revolution, AI, Synthetic biology

- Inventions cannot be uninvented; knowledge proliferates

#horizontalrule

=== What are you?
<what-are-you>
#block[
- ==== What are you? Explain in one sentence to a 10 year old.
  <what-are-you-explain-in-one-sentence-to-a-10-year-old.>

- ==== What are you? Explain in two sentences to a university student.
  <what-are-you-explain-in-two-sentences-to-a-university-student.>

- ==== What are you? Explain to a university teacher.
  <what-are-you-explain-to-a-university-teacher.>

- ==== What are you? Explain to an economics research scholar.
  <what-are-you-explain-to-an-economics-research-scholar.>

]

#horizontalrule

=== Some more prompting
<some-more-prompting>
==== What role could and should generative AI play for supporting effective and engaging evidence-based learning for economists?
<what-role-could-and-should-generative-ai-play-for-supporting-effective-and-engaging-evidence-based-learning-for-economists>
==== What challenges AI poses to the traditional role of the teacher in the classroom?
<what-challenges-ai-poses-to-the-traditional-role-of-the-teacher-in-the-classroom>
==== What challenges AI poses to policy integrity and evaluation of policies?
<what-challenges-ai-poses-to-policy-integrity-and-evaluation-of-policies>
=== Fiscal Policy Advisor
<fiscal-policy-advisor>
==== How do 1% increase in GST affects inflation and its consequences on poor segments of the society?
<how-do-1-increase-in-gst-affects-inflation-and-its-consequences-on-poor-segments-of-the-society>
== What will Iqbal say to youth about use of Social Media
<what-will-iqbal-say-to-youth-about-use-of-social-media>
#block[
Allama Iqbal, known for his deep reflections on spirituality, selfhood (#emph[Khudi];), and societal progress, would likely have a nuanced view of social media’s impact on youth. Here’s what he might say:

#strong[\1. Distraction from Purpose:] Iqbal would likely be concerned about social media’s ability to distract youth from their true purpose. He often emphasized the need for deep self-reflection and personal growth, and he might view the constant scrolling and superficial interactions on social media as hindrances to achieving #emph[Khudi];. He might say, #strong[#emph["The pursuit of likes and followers should not replace the pursuit of self-realization and greater goals."];]

#strong[\2. Lost Sense of Identity:] Iqbal believed in the importance of individual and cultural identity. He might see social media as contributing to a loss of self, where youth are too often influenced by external validation and trends rather than their inner values and cultural heritage. He could warn that #strong[#emph["In a world of filters and illusions, do not lose your true self. Your identity is not what others see online, but what you discover within."];]

#strong[\3. Potential for Positive Change:] Despite his concerns, Iqbal would recognize the potential of social media as a powerful tool for positive change. He might encourage the youth to use these platforms to raise awareness about important issues, foster meaningful connections, and promote justice and knowledge. He could say, #strong[#emph["Use your voice on these platforms as a means to awaken and uplift, not just to entertain."];]

#strong[\4. Spiritual and Intellectual Balance:] Iqbal would likely urge the youth to balance their time on social media with activities that promote intellectual growth and spiritual reflection. He might remind them that while social media can be a tool for learning and connection, it should not replace the deeper, more personal journey of seeking knowledge and spiritual fulfillment. He might caution, #strong[#emph["Do not let fleeting moments of entertainment steal the time meant for the pursuit of wisdom and self-enlightenment."];]

#strong[\5. The Power of Influence:] Iqbal would be keenly aware of social media’s power to influence minds. He would advise youth to be discerning in their consumption of content, warning them not to fall prey to misinformation or hollow trends. He might say, #strong[#emph["Just as a gardener tends to what he plants, so too must you guard your mind from the weeds of falsehood and idle talk."];]

In summary, Iqbal would likely see both the dangers and the opportunities in social media. He would call on the youth to use these platforms wisely, ensuring they foster self-growth, preserve cultural identity, and contribute meaningfully to society, rather than getting lost in the distractions of the digital world.

]

#horizontalrule

=== Race between Education and Technology
<race-between-education-and-technology>
#box(image("images/race_tech_edu.png"))

#block[
Many a times technology races ahead of education. This leads to social pain and inequality. The whole educational system has to revolutionize to keep up. Well, our world has always been in a race between technology and education. Usually, these two go hand in hand, but there are some points in history where technology races so far ahead that education can barely keep pace.

]

#horizontalrule

=== The Role of AI in Idea Generation
<the-role-of-ai-in-idea-generation>
- AI can assist in generating ideas, refining questions, and clarifying thought processes.

- Humans still need to iterate and prototype, but AI can generate a high volume of ideas, which humans often struggle with.

#quote(block: true)[
==== The best way to have a good idea is to have lots of ideas. Humans will need to continue the process of prototyping, testing, and iterating, but humans consistently struggle to produce large quantities of different and new ideas.’
<the-best-way-to-have-a-good-idea-is-to-have-lots-of-ideas.-humans-will-need-to-continue-the-process-of-prototyping-testing-and-iterating-but-humans-consistently-struggle-to-produce-large-quantities-of-different-and-new-ideas.>
]

#horizontalrule

=== Comming Wave & Jobs
<comming-wave-jobs>
#block[
- ==== "AI offers vast tools for augmenting workers and enhancing work. We must master these tools and make them work for us." David Autor
  <ai-offers-vast-tools-for-augmenting-workers-and-enhancing-work.-we-must-master-these-tools-and-make-them-work-for-us.-david-autor>

- ===== As per David Autor, the problem is that older models assumed technology ” might raise some boats more than others, but would’nt lower any boats. However, as digital technology transformed the globaly economy there was "lots of evidence people were made worse off."
  <as-per-david-autor-the-problem-is-that-older-models-assumed-technology-might-raise-some-boats-more-than-others-but-wouldnt-lower-any-boats.-however-as-digital-technology-transformed-the-globaly-economy-there-was-lots-of-evidence-people-were-made-worse-off.>

]
#block[
Let me give you a quick historical example. In the 15th century, technology raced ahead as a great piece of technology was invented: the printing press, which allowed books to be printed much cheaper than ever before. Unfortunately, only a small fraction of the population knew how to read, leading to massive social conflicts and inequality. Ultimately, the whole educational system had to revolutionize to keep up. This led to the birth of the first universities and schools.

]

#horizontalrule

=== 
<section-4>
- "Benjamin Bloom’s 2 Sigma Study"

  - "1-to-1 Tutoring: Two Standard Deviation Improvement"
  - "Unlocking Potential: From Average to Exceptional Students"
  - "AI Tutoring: A Scalable Solution to the 2 Sigma Problem"

- "Introducing Khanmigo: Your Personal AI Tutor"

- "Enhanced Learning Experience: Socratic Conversations"

- "AI Assistance in Math, Programming, and Literature"

- "Empowering Students with Personal Coaching"

- "Guidance, Academic Support, and Career Counseling"

- "AI-Powered Coaching for Every Student"

== Two Sigma Problem
<two-sigma-problem>
#box(image("images/2_sigma.png"))

== AI Writing and Reading Coach
<ai-writing-and-reading-coach>
- "Collaborative Writing with AI Assistance"

- "Enhancing Writing Skills: AI-Student Collaboration"

- "Feedback, Guidance, and Improvement in Writing"

- "Interactive Reading Comprehension with AI"

- "Analyzing Texts, Answering Questions, and Providing Insights"

- "Enhancing Critical Thinking and Analysis Skills"

- "AI-Powered Teaching Assistant for Teachers"

- "Transformative Potential of AI in Education"

- "Enhancing AI Capabilities for a Magical Learning Experience"

- "Combining Human Intelligence with AI for Educational Advancement"

== Paul Samuelson as your Assistant
<paul-samuelson-as-your-assistant>
#block[
==== Give a learning outcomes on consumer theory lecture in 3 points with 15 words for each point
<give-a-learning-outcomes-on-consumer-theory-lecture-in-3-points-with-15-words-for-each-point>
==== Differentiate between Marshalian and Hicksian demand function, restrict response to 50 words
<differentiate-between-marshalian-and-hicksian-demand-function-restrict-response-to-50-words>
==== Explain it in little detail, restrict response to 100 words
<explain-it-in-little-detail-restrict-response-to-100-words>
==== Give some mathematics
<give-some-mathematics>
==== Provide a real life example
<provide-a-real-life-example>
==== Give slides on Marshallian and Hicksian demand function with learning outcomes
<give-slides-on-marshallian-and-hicksian-demand-function-with-learning-outcomes>
==== Provide a quiz on Marshallian and Hicksian demand function
<provide-a-quiz-on-marshallian-and-hicksian-demand-function>
]

#horizontalrule

=== The 3 Principles of Macroeconomic Policy Formulation using Gen AI
<the-3-principles-of-macroeconomic-policy-formulation-using-gen-ai>
#block[
#block[
==== #box(image("AI_economists1_files\\mediabag\\graph-up-arrow.svg", width: 50px)) #strong[Predictive Analytics for Policy Decisions]
<predictive-analytics-for-policy-decisions>
Gen AI can analyze vast amounts of economic data to predict trends such as inflation, unemployment, and GDP growth. This enables policymakers to make more informed decisions by forecasting economic conditions with greater accuracy.

#horizontalrule

==== #box(image("AI_economists1_files\\mediabag\\funnel-fill.svg", width: 50px)) #strong[Real-Time Data Processing and Insights]
<real-time-data-processing-and-insights>
Gen AI can process real-time economic data from global markets, providing immediate insights into economic shocks, demand fluctuations, and supply chain disruptions. This helps in dynamic policy adjustments to stabilize the economy.

#horizontalrule

==== #box(image("AI_economists1_files\\mediabag\\gear-wide-connected.svg", width: 50px)) #strong[Scenario Analysis and Policy Simulations]
<scenario-analysis-and-policy-simulations>
AI can simulate multiple policy scenarios, helping policymakers assess the potential outcomes of different strategies. This allows for better risk assessment and policy optimization, ensuring that policies are robust and adaptable to various macroeconomic environments.

]
]

#horizontalrule

== These key points emphasize how #strong[Gen AI] can significantly enhance the process of macroeconomic policy formulation by improving forecasting, decision-making, and scenario planning.
<these-key-points-emphasize-how-gen-ai-can-significantly-enhance-the-process-of-macroeconomic-policy-formulation-by-improving-forecasting-decision-making-and-scenario-planning.>
== Text to image
<text-to-image>
==== Prompt : Create an image for QAU students sitting as a community learners in a classroom.
<prompt-create-an-image-for-qau-students-sitting-as-a-community-learners-in-a-classroom.>
#block[
#block[
#box(image("images/interactive_learning.webp"))

]
#block[
#box(image("images/interactive_learning1.webp"))

]
]

#horizontalrule

=== Old vs New Model
<old-vs-new-model>
#box(image("images/hall.webp"))

Yet, our educational institutions have not evolved much. We still put people in lecture halls for one-size-fits-all teaching, and many companies only offer a couple of days of training per year. This model is outdated.

== Things to be discussed
<things-to-be-discussed>
- Customised advanced tools: Policy Advisor, Fiscal Policy Advisor, Economics Expert,…

- Coding, Mathematics, Data Analysis …

- Technology’s Impact on Humanity

=== Containment: Can We Do It?
<containment-can-we-do-it>
- Navigating the Coming Wave

- AI and Wars

- How Ukraine countered largest every military deployment of Russia

- AI and the Future of Work

#horizontalrule

=== Prompt
<prompt>
==== You are hiring a "waiter" The typical daily wage rate is PKR 800. You have 2 candidates. Person 1: Has 1 year(s) of experience in this role. Requests PKR 1100. Person 2: Has 0 year(s) of experience in this role. Requests PKR 900. Who would you hire? You have to pick one.
<you-are-hiring-a-waiter-the-typical-daily-wage-rate-is-pkr-800.-you-have-2-candidates.-person-1-has-1-years-of-experience-in-this-role.-requests-pkr-1100.-person-2-has-0-years-of-experience-in-this-role.-requests-pkr-900.-who-would-you-hire-you-have-to-pick-one.>
==== Explain Solow Growth model to an undergraduate studet in 70 words.
<explain-solow-growth-model-to-an-undergraduate-studet-in-70-words.>
==== Simulate the Solow growth model and plot the results in a four chart.
<simulate-the-solow-growth-model-and-plot-the-results-in-a-four-chart.>
== Resources
<resources>
- #link("https://www.youtube.com/watch?v=ArI6albrkuY")[Re-inventing Education for the Digital Age | David Middelbeck | TEDxMünster]

- #link("https://sites.google.com/view/lastunen/ai-for-economists")[AI for Economists: Prompt & Resources]

- #link("https://teachingnaked.com/prompts/")[Teaching Naked Teaching with AI]

- #link("https://www.economist.com/the-economist-explains/2024/01/25/what-is-prompt-engineering-for-artificial-intelligence")[What is Prompt Enginering]

- Policy Advisor

- Fiscal policy advisor

- Economics expert

- Tutor me

- Duolingo

- R for economics and Econometrics

- Stata ai

- curipid.com Lessons in seconds

- murf.ai Text to speech

- Myheritage

- Snythesia video maker

== Useful Books (2024)
<useful-books-2024>
#block[
#block[
#box(image("images/book1.jpeg"))

]
#block[
#box(image("images/book2.jpeg"))

]
#block[
#box(image("images/book3.jpeg"))

]
#block[
#box(image("images/book4.jpeg"))

]
#block[
#box(image("images/book5.jpeg"))

]
]

#horizontalrule

=== Thank You!
<thank-you>
#figure([
#box(image("images/thank_you.webp"))
], caption: figure.caption(
position: bottom, 
[
Thank You
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)


#strong[Prof.~Dr.~Zahid Asghar, QAU, Islamabad]

== What Sets Successful People Apart? A Commitment to Reading, Continuous Learning, and Adapting to Technological Change
<what-sets-successful-people-apart-a-commitment-to-reading-continuous-learning-and-adapting-to-technological-change>

#horizontalrule

=== Questions or Comments?
<questions-or-comments>
#strong[Contact Information:]

- #strong[Email:] #link("mailto:g.zahid@gmail.com")[g.zahid\@gmail.com]

- #strong[LinkedIn:] #link("https://www.linkedin.com/in/zahid-asghar/")

- #strong[Twitter:] #link("https://twitter.com/Zahadasghar")[#cite(<Zahadasghar>, form: "prose");]

- #strong[YouTube:] #link("https://www.youtube.com/c/ZahidAsghar")
