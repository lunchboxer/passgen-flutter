# Project Requirements Form

## Basic Project Information

**Project Name:** 
Passgen

**Project Type:** 
mobile app

**Primary Purpose/Goal:** 
quickly and easily generate strong passwords in the xkcd style.

**Target Users:** 
myself and nerds who use Android and F-droid

## Functional Requirements

**Core Features:** 
- generate xkcd-style passwords
- allow user to select length, complexity, and special characters
- quickly and easily new generate passwords

**User Stories:** 

1. As the user opens the app, it should automatically generate password using the default settings.
2. Allow the user to copy the generated password to the clipboard with a single button
3. Allow the user to modify the following parameters without leaving the view:
    - number of words in the password (default: 3)
    - add a non-word symbol at the end (default: false)
    - add a random number at the end (default: false)
    - capitalization (default: true)
    - total length of the password in characters (default: unconstrained)
    - separator between words (default: "-")
4. Allow the user to modify the default settings in a settings view.

**Data Requirements:** 

The words will be gathered from a plain text file. There is a main list and a much shorter list of short words to use when trying to meet word length requirements. The lists are small enough files that they should be integrated directly in to the binary of the app if possible.

the main list is at "./assets/words.txt" and the short list is at "./assets/shortwords.txt"

**Integration Requirements:** 

None

## Technical Constraints

**Technology Stack Preferences:** 

Flutter, Android, Material Design

**Platform Requirements:** 

Android

**Performance Requirements:** 

It needs to be fast and small. Load times should be under a second.

**Security Requirements:** 

No permissions are needed to run the app. No internet access. No data is stored.

## Non-Functional Requirements

**Usability Requirements:** 
The app should show as much of the functionality (excluding default settings) as possible on a single screen without needing to scroll. For smaller screens the password generation parameter buttons or inputs should re-flow elegantly in a vertically scrollable view.

**Reliability Requirements:** 
N/A

**Scalability Requirements:** 
none. Keep it simple.

**Maintenance Requirements:** 
None. keep it simple.

## Project Constraints

**Timeline:** 

**Budget/Resource Constraints:** 

**Regulatory/Compliance Requirements:** 

N/A

## Success Criteria

**Definition of Done:** 

App compiles and runs on Android without errors.

**Key Metrics:** 

**Acceptance Criteria:** 

App compiles and runs on Android without errors.

## Additional Context

**Existing Solutions:** 
<!-- What alternatives exist? Why build this instead? -->

**Assumptions:** 
<!-- What are you assuming about users, technology, market, etc.? -->

**Risks and Concerns:** 
<!-- What could go wrong? What are you worried about? -->

**Future Considerations:** 
<!-- What features or changes might come later? -->

---

**Form Completion Date:** 
2025-08-13

**Completed by:** 
James Smith
