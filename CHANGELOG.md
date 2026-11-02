# CPF-Code change log

This file records every change to the CPF code after the release of CPF 2.0.
The newest changes are at the top.

Each entry gives the date, the files changed and a short description. It also says
whether the change affects the CPF data and what users need to do. The "Code" link
opens the exact lines that were changed on GitHub.

Questions or problems: www.cpfdata.com/forum

<!--
HOW TO ADD AN ENTRY (copy the template below to the top of "Changes", under this comment)

## YYYY-MM-DD — CPF 2.0.x
- **Survey or Master** `file_name.do`: what was changed and why, in one or two sentences.
  - Affects data: yes (which variables, which survey or waves) / no
  - Action for users: e.g. re-run HILDA and the Append step / none
  - Code: https://github.com/cpfdata/CPF-Code/commit/<commit-id>

Notes:
- Increase the last number of the version for each update (2.0.1, 2.0.2, ...).
- Several small changes made on the same day can go under one date as separate bullets.
- To get the commit link: open the repository on GitHub, click "Commits",
  open your change and copy the address from the browser.
-->

## Changes

## 2026-11-02 — CPF 2.0.1
- **All surveys** (`xx_02_Harmonize` files of each survey, `_11_Append.do`, `_12_Labels.do`,
  `automatic_codebook.do`): new variable `srh3`, self-rated health in 3 categories
  (1 Good, 2 Average, 3 Poor), recommended for cross-country comparisons.
  The original 5-point scales differ between surveys (balanced or unbalanced), so `srh3`
  is based on the position on the scale, the same in all surveys: the two top categories = 1,
  the middle category = 2, the two bottom categories = 3. The bottom category (Poor) is the
  most comparable across surveys.
  - Affects data: yes, new variable `srh3` added; `srh5` is unchanged
  - Action for users: to get `srh3`, re-run the country do-files and the Append and Labels steps
  - Code: https://github.com/cpfdata/CPF-Code/commit/541582d43293ca307b2e17057ad5a64a2a702b1f
    and https://github.com/cpfdata/CPF-Code/commit/95b4f409d2f736a927fbe1df1965b6205fc45fd5
- **KLIPS** `ko_02_Harmonize.do`: corrected the description of the original self-rated health
  scale in the code comments (translated Korean answer categories).
  - Affects data: no

---

## 2025-07-24 — CPF 2.0 (release)

Release of CPF 2.0. Main changes compared with CPF 1.6:

- **Surveys:** added the Netherlands (LISS). Removed Russia (RLMS); see
  `04_RLMS/RLMS_excluded_CPF2.0.txt`.
- **Waves:** updated to the following data versions: HILDA 20 waves, KLIPS 26,
  PSID up to 2023, SHP 25, SOEP v40, UKHLS 14 (plus BHPS), LISS up to 2024.
- **Code structure:** new master files `1_CPF-Folder-Setup.do` and
  `2_CPF-Data-Run.do` (they replace `1_Folder_setup.do` and
  `2_CPF_Main__Fill_and_run.do`).
- **PSID:** a temporary updated version of `psidtools` is included
  (`03_PSID/psidtools cpf2/`) to handle the 2023 wave.

Full description: CPF 2.0 manual and codebook at www.cpfdata.com.

---

## Earlier versions

Code for earlier versions is available as tagged releases on GitHub:
[v1.6](https://github.com/cpfdata/CPF-Code/tree/v1.6) ·
[v1.5](https://github.com/cpfdata/CPF-Code/tree/v1.5) ·
[v1.4](https://github.com/cpfdata/CPF-Code/tree/v1.4) ·
[v1.1](https://github.com/cpfdata/CPF-Code/tree/v1.1) ·
[v1.0](https://github.com/cpfdata/CPF-Code/tree/v1.0).
The CPF 1.6 code is also kept on the branch `CPF-ver-1.6(old_archived)`.
