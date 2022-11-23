# Met Office brand LaTex templates


## Satellite Applications Tech Memo (SATM)

### Install SATM LaTeX class

```bash
module use /project/SatImagery/utils/modulefiles
module load satools
cd ~
install_satm_latex_class
```

The `install_satm_latex_class` command should:

- Install SATM class file in `~/texmf/tex/latex`
- Create a link to SATM layout file in `~/.lyx/layouts`
- Add some templates in current working directory (or user `HOME`)

LyX users may need to reconfigure for the new class to be picked up.


## Template for presentation

The `beamer` folder contains a template and required macros for the beamer
template in a style file.  You can install the style macros in order
to avoid copying it alongside the LaTex file,

```bash
git clone https://github.com/MetOffice/brand-latex
mkdir -p ~/texmf/tex/latex/metomacros
cp brand-latex/beamer/metomacros.sty ~/texmf/tex/latex/metomacros/
teshash ~/texmf
```


> **Note**
> New SharePoint location for Met Office Logos
> [Met Office Logos](https://metoffice.sharepoint.com/:f:/r/sites/MetOfficeBrandExperienceHubExt/External%20Documents/Brand%20templates/Logos?csf=1&web=1&e=I0Nb8d)

