# Course: System Analysis & Design  (level id "deep-cse-4-6", lesson ids "deep-cse-4-6-01".."-25")
Builds on Database Management Systems (deep-cse-4-2: ER model, mapping, normalization are only recapped here) and runs next to
Software Engineering (deep-cse-4-4: process models, agile, testing and project management in depth) and Management Information
Systems (deep-cse-4-7: types of information systems in depth). Those are mentioned and kept light. Focus: the analyst's view of
the SDLC, systems thinking, feasibility, requirements gathering, process/logic/data/object modeling, input/output/UI design,
architecture choices, implementation, conversion and maintenance. One running example is reused across lessons: a pharmacy chain
in Dhaka ("ShasthoPharma") moving from paper registers to a computerised sales, stock and prescription system.
01 What systems analysis and design is: system, information system and its parts (people, procedures, data, software, hardware, network), IS types in one paragraph, the systems analyst's role and skills, stakeholders (owners, users, designers, builders), course map
02 Systems thinking: components, boundary, environment, interfaces, input/process/output, constraints, purpose; open vs closed systems; subsystems and decomposition; coupling and cohesion idea; feedback and control; entropy
03 The SDLC from the analyst's view: planning, analysis, design, implementation, support; deliverables and gates per phase; waterfall, iterative/phased, prototyping, RAD and agile in brief; structured vs object-oriented approach; choosing an approach
04 Project initiation: where requests come from, the system request, problem vs symptom, cause-and-effect (fishbone) and 5 whys, scope and scope creep, preliminary investigation, project charter, a Gantt chart in brief
05 Feasibility study: why, operational feasibility and the PIECES framework, technical, schedule, legal, organizational/political feasibility, TELOS, writing the feasibility report and go/no-go
06 Economic feasibility: tangible and intangible costs and benefits, one-time vs recurring, payback period, ROI, time value of money, NPV worked in taka, break-even, comparing alternatives
07 Requirements: what a requirement is, business/user/functional/non-functional requirements, writing good requirements, as-is vs to-be, business process automation, improvement and reengineering (BPA/BPI/BPR)
08 Fact-finding I, interviews: who to interview, planning, open and closed questions, probes, pyramid/funnel/diamond structures, conducting, listening, the interview report, common pitfalls
09 Fact-finding II: questionnaires (question types, Likert scales, sampling, pilot test), observation (and the Hawthorne effect), document and record analysis, comparing techniques
10 Fact-finding III, group techniques: JAD sessions (sponsor, facilitator, scribe, users, ground rules, room), brainstorming, prototyping for requirements, focus on modern options (online surveys, analytics)
11 Organizing requirements: requirement IDs, prioritization (MoSCoW), the requirements specification (SRS) contents, validation and review, traceability matrix, managing change and scope creep
12 Process modeling I: what a DFD is and why, symbols (Gane-Sarson vs DeMarco-Yourdon), external entity, process, data flow, data store, DFD rules, the context diagram worked for the pharmacy
13 Process modeling II: decomposition into level 0 and level 1, numbering, balancing worked, common errors (black hole, miracle, gray hole), logical vs physical and current vs proposed DFDs
14 Logic modeling I: why process logic needs its own tools, structured English (sequence, decision, repetition), decision trees, worked discount example
15 Logic modeling II, decision tables: conditions, actions, rules, 2^n rules, filling the table, simplifying with indifference ("-"), checking completeness, when to use which tool
16 The data dictionary: why, data elements, data structures, data flows, data stores, processes and entities entries, notation (=, +, [ | ], { }, ( ), * *), linking DFD and dictionary
17 Data modeling for analysts: from nouns to entities, attributes and identifiers, relationships, cardinality and modality in crow's foot, ERD for the pharmacy, linking ERD to DFD data stores, normalization only in brief (DBMS course)
18 Object-oriented analysis and use cases: objects and classes recap, UML diagram families, actors, use cases, system boundary, include and extend, writing a use case description (main flow, alternate flows)
19 Activity and sequence diagrams: activity nodes, decisions, fork/join, swimlanes; lifelines, messages, activation, return; turning a use case into a sequence diagram
20 Class and state diagrams basics: analysis classes, attributes and operations, associations and multiplicity, generalization, aggregation vs composition, state machine diagrams for an order
21 Design strategy and architecture: logical to physical, build vs buy vs outsource, RFP, alternatives matrix, client-server, two/three/n-tier, thin vs thick client, cloud (IaaS, PaaS, SaaS), choosing with non-functional requirements
22 Output and input design: output types (detail, summary, exception reports), media, good report rules; input design, source documents, batch vs online, validation checks (completeness, type, range, format, check digit, existence), coding schemes
23 User interface design: principles (consistency, feedback, error prevention, easy reversal, low memory load), navigation, layout, forms, messages, accessibility, Bangla/English text, storyboards and prototyping, usability testing in brief
24 Implementation and conversion: construction and testing in brief, documentation, training, data conversion, conversion strategies (direct, parallel, pilot, phased) with risk/cost, post-implementation review
25 Maintenance and wrap-up: corrective, adaptive, perfective, preventive maintenance, maintenance cost, change requests, configuration management, performance and security monitoring, system retirement, course recap and what next
