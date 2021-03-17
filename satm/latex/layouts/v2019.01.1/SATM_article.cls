\LoadClass[a4paper]{article}

% The version and date of this file
\newcommand\MetOfficeVersionOnly{v2019.01.1}
\newcommand\MetOfficeVersionDate{2019/01/07}
\newcommand\MetOfficeVersionContact{yaswant.pradhan@metoffice.gov.uk}

\typeout{Using SATM LaTeX class: \MetOfficeVersionDate, \MetOfficeVersionOnly}
\typeout{All queries to: \MetOfficeVersionContact}

% logo file names
\newcommand\IncludeDir{/project/SatImagery/utils/brand/satm/lyx/layouts/v2019.01.1}
\newcommand\StandardLogo{\IncludeDir/images/MO_MASTER_black_mono}
\newcommand\HadleyLogo{\IncludeDir/images/MOHC_MASTER_black_mono}


% We need LaTeX 2e or better
\NeedsTeXFormat{LaTeX2e}

% Required packages
\RequirePackage{ifthen}
\RequirePackage{fancyhdr}
\RequirePackage{color}
\RequirePackage{colortbl}
\RequirePackage{graphicx}
\RequirePackage{lastpage}
\RequirePackage[absolute]{textpos}
\RequirePackage{setspace}
\RequirePackage{hyphenat}
\RequirePackage[english]{babel}

% margin/header/footer sizes
\newlength{\LeftMargin} \setlength{\LeftMargin}{25.4mm}
\newlength{\RightMargin} \setlength{\RightMargin}{25.4mm}
\newlength{\TopMargin} \setlength{\TopMargin}{30mm}
\usepackage[a4paper,%
            hmargin={\LeftMargin,\RightMargin},%
            top=\TopMargin,%
            bottom=25.4mm,%
            headheight=12.5mm,%
            headsep=0mm]{geometry}

% Define boolean variables and processing options
%================================================

% If preparing an external report this allows the customer's name to
% be inserted onto a legal disclaimer on the second page of the report
\newboolean{disclaimer}
\setboolean{disclaimer}{false}

% set colour for banner at bottom of title page.
% default is 'core_black' so this boolean sets it to 'core_green'
\newboolean{green}
\setboolean{green}{false}
\DeclareOption{green}{%
    \typeout{Option "green": setting title page banner to green}
    \setboolean{green}{true}
}

% Printing layout
\newboolean{print}
\setboolean{print}{false}
\DeclareOption{print}{%
    \typeout{Option "print": Setting fill pages}
    \setboolean{print}{true}
}

% Hadley Center Logo
\newboolean{hadley}
\setboolean{hadley}{false}
\DeclareOption{hadley}{%
    \typeout{Option "hadley": Using Hadley Center logos}
    \setboolean{hadley}{true}
}

% Use RGB colors
\newboolean{rgb}
\setboolean{rgb}{false}
\DeclareOption{rgb}{%
    \typeout{Option "rgb": Defining colors by rgb}
    \setboolean{rgb}{true}
}

% Hook for "english" option, which appears to be passed by default
% from Lyx, to stop the catch below from failing when using Lyx
\DeclareOption{english}{%
    \typeout{Option "english": No action, placeholder for lyx usage}
}

% Catch unspecified options
\DeclareOption*{%
    \PackageError{MO}{Unknown option: '\CurrentOption'}
}

\ProcessOptions

% Arial (Helvetica) font
\renewcommand\sfdefault{phv} % Load helvetica for sans ser
\renewcommand\familydefault{\sfdefault} % Use sans serif by default

% copyright string
\newcommand{\CrownCopyright}{%
    \copyright\ Crown Copyright\ \number\year, Met Office
}

% Define Met Office colours using either RGB or CMYK
% these are the latest brand colours as at 14 Jun 2018
% https://metnet2.metoffice.gov.uk/content/our-colours
\ifthenelse{\boolean{rgb}}
{%
    \definecolor{core_green}   {RGB}{185,220,12}
    \definecolor{core_black}   {RGB}{42,42,42}
    \definecolor{spring_green} {RGB}{80,185,164}
    \definecolor{summer_blue}  {RGB}{0,122,169}
    \definecolor{autumn_orange}{RGB}{228,116,82}
    \definecolor{winter_grey}  {RGB}{161,160,170}
}{%
    \definecolor{core_green}   {cmyk}{0.30,0.00,0.90,0.00}
    \definecolor{core_black}   {cmyk}{0.72,0.62,0.58,0.72}
    \definecolor{spring_green} {cmyk}{0.66,0.00,0.43,0.00}
    \definecolor{summer_blue}  {cmyk}{0.85,0.40,0.17,0.03}
    \definecolor{autumn_orange}{cmyk}{0.06,0.64,0.68,0.00}
    \definecolor{winter_grey}  {cmyk}{0.40,0.32,0.25,0.06}
}

% Create a command which works like the author, date and title commands but
% allows the addition of a protective marking set marking to blank by default
% over-ride with large, bold text if the \marking command is given
\newcommand{\ProtectMark}[1]{#1}
\renewcommand{\ProtectMark}{}
\newcommand{\marking}[1]{%
    \renewcommand{\ProtectMark}{\large \textbf{#1}}
}


% Create a command which allows you to specify your group
\newcommand{\ResearchGroup}[1]{#1}
\renewcommand{\ResearchGroup}{}
\newcommand{\SAGroup}[1]{%
    \renewcommand{\ResearchGroup}{\large{#1}}
}

% Create a command which allows you to specify the SATM number
\newcommand{\SATMID}[1]{#1}
\renewcommand{\SATMID}{}
\newcommand{\SATM}[1]{%
    \renewcommand{\SATMID}{\LARGE{Satellite Applications Technical Memo #1}}
}

% Create a command which works like the author, date and title
% commands but allows the addition of a customer + disclaimer
\newcommand{\disclaimer}[1]{%
    \newcommand{\CustomerName}{#1}
    \setboolean{disclaimer}{true}
}

% define macros to set title page banner and text colour
% default is white text on black banner
\newcommand{\CoverColour}{core_black}
\newcommand{\CoverText}{white}
\ifthenelse{\boolean{green}}
{%
    % set banner to green with black text
    \renewcommand{\CoverColour}{core_green}
    \renewcommand{\CoverText}{black}
}{}

% don't draw header/footer rule separators ... ever!
\renewcommand{\headrulewidth}{0.0mm}
\renewcommand{\footrulewidth}{0.0mm}

% set these modules to define textblock position units
\setlength{\TPHorizModule}{10mm}
\setlength{\TPVertModule}{10mm}

% Modify maketitle, causing it to create our new title page Note we
% force the page counter to start from -3, and the first document page
% to start from 1... Ensuring the toc processes don't get confused if
% we have the extra blank page (starts from -3 because the maximum
% possible number of title pages is 4 when using both the print option
% and providing a disclaimer)
\renewcommand{\maketitle}{%
    \setcounter{page}{-3}
    \MOCover
    \ifthenelse{\boolean{disclaimer}}
    {%
        \MODisclaimer
    }{}
    \setcounter{page}{1}
    \MOStyle
}

% End with the Met Office closing page
\AtEndDocument{%
    \MOClosingPage
}

% Redefine pagestyle{plain} to use the Met Office style (this is used
% by Chapter & Section)
\fancypagestyle{plain}{%
    \MOStyle
}

% Page Style
%============
\newcommand{\MOStyle}{%

    % Basic page settings
    \pagestyle{fancy}
    \setstretch{1.5}
    \textblockcolor{white}

    % header
    % - Select either standard or Hadley Center logo for left side of the header
    \fancyhead[L]{
        \begin{textblock}{6.0}[0,1](2.0,2.0)
        \ifthenelse{\boolean{hadley}}{%
            \includegraphics[width=44mm]{\HadleyLogo}
        }{%
            \includegraphics[width=44mm]{\StandardLogo}
        }
        \end{textblock}
    }

    \fancyhead[C]{%
        \textblockcolor{white}
        \begin{textblock}{6.0}[0.5,0.5](10.5,1)
        \centering
        \ProtectMark
        \end{textblock}
    }
    \fancyhead[R]{}

    % footer
    % - Add copyright / protective marking at left
    % - Add page number / page count at right
    \fancyfoot[L]{\CrownCopyright}
    \fancyfoot[C]{%
        \textblockcolor{white}
        \begin{textblock}{6.0}[0.5,0.5](10.5,29)
            \centering
            \ProtectMark
        \end{textblock}
    }
    \fancyfoot[R]{\thepage\ of \pageref{LastPage}}
}

% Disclaimer Page
% ===============
\newcommand{\MODisclaimer}{%
    \pagestyle{empty}

    \input \IncludeDir/disclaimer.tex

    \pagestyle{fancy}
    \fancyfoot[L]{\CrownCopyright}
    \fancyhead[C]{%
        \textblockcolor{white}
        \begin{textblock}{6.0}[0.5,0.5](10.5,1)
        \centering
        \ProtectMark
        \end{textblock}
    }
    \fancyfoot[C]{%
        \textblockcolor{white}
        \begin{textblock}{6.0}[0.5,0.5](10.5,29)
        \centering
        \ProtectMark
        \end{textblock}
    }

    \newpage
    % Add another blank page if using the print layout
    \ifthenelse{\boolean{print}}
    {%
        \thispagestyle{empty}
        \mbox{}
        \newpage
    }{}
}

% Cover Page
% ============
\newcommand{\MOCover}{%

    \thispagestyle{empty}

    \textblockcolor{white}
    \begin{textblock}{6.0}[0.5,0.5](10.5,1)
    \centering
    \ProtectMark
    \end{textblock}

    % Add MO logo graphics, either standard or Hadley Center
    \begin{textblock}{15}(1.83,2.27)
    \ifthenelse{\boolean{hadley}}
    {%
        \noindent\includegraphics[width=73.8mm]{\HadleyLogo} \\
    }{%
        \noindent\includegraphics[width=73.8mm]{\StandardLogo}\\
    }
    \end{textblock}

    % Print the title, date and author information onto the cover
    \begin{textblock}{15.0}(2.5,8.5)
    \hangindent=3pt  % add this to get wrapped lines in the title to line up
            % correctly (seems sort of dumb but I couldn't get it any other way)
    \setstretch{1.6}
    \noindent
    \nohyphens{%
        \begin{doublespace}
        \Huge\textbf\@title
        \vspace{10mm}\\\SATMID
        \vspace{15mm}\\\Large\@author
        \vspace{1mm}\\\ResearchGroup
        \vspace{15mm}\\\Large\@date
        \end{doublespace}
    }
    \end{textblock}


    % Add banner at bottom of title page
    \textblockcolour{\CoverColour}
    \begin{textblock}{21.0}(0.0,26.84)
    \vspace{1.25cm}
    \textcolor{\CoverText}{%
        \hspace*{\LeftMargin} www.metoffice.gov.uk \hfill \copyright\ Crown Copyright\ \number\year, Met Office \hspace*{\RightMargin}\\
        \phantom{0}\\
        \phantom{0}\\
        \phantom{0}\\
    }
    \end{textblock}

    \textblockcolour{\CoverColour}
    \begin{textblock}{6.0}[0.5,0.5](10.5,29)
    \centering
    \textcolor{\CoverText}{\ProtectMark}
    \end{textblock}

    \textblockcolor{white}

    % Onto the next page, insert an additional blank page if using the
    % print layout, and ensure the blank page is white regardless of the
    % title page colour
    \null\newpage
    \ifthenelse{\boolean{print}}
    {%
        \thispagestyle{empty}
        \mbox{}
        \newpage
    }{}
}

% Closing Page
%==============
\newcommand{\MOClosingPage}{%

    \clearpage\newpage

    \pagestyle{empty}

    % If the document had an un-even page count this adds a blank fill
    % page to ensure the back cover page is on the back of the document
    % when printing double-sided
    \ifthenelse{\boolean{print}}
    {%
        \ifodd\thepage
        \begin{center}
            This page is intentionally left blank
        \end{center}
        \newpage
        \fi
    }{}

    \vspace*{\fill}
    \begin{textblock}{4.0}(3.2, 23.1)
    \noindent Met Office\\
    FitzRoy Road\\
    Exeter\\
    Devon\\
    EX1 3PB\\
    United Kingdom
    \end{textblock}


    % Add banner at bottom of back cover page
    \textblockcolour{\CoverColour}
    \begin{textblock}{21.0}(0.0,26.84)
    \vspace{1.25cm}
    \textcolor{\CoverText}{%
        \hspace*{\LeftMargin} www.metoffice.gov.uk \hfill \copyright\ Crown Copyright\ \number\year, Met Office \hspace*{\RightMargin}\\
        \phantom{0}\\
        \phantom{0}\\
        \phantom{0}\\
    }
    \end{textblock}

    \textblockcolour{\CoverColour}
    \begin{textblock}{6.0}[0.5,0.5](10.5,29)
    \centering
    \textcolor{\CoverText}{\ProtectMark}
    \end{textblock}
    %


    \textblockcolor{white}
    \begin{textblock}{8}[1,1.2](18.5,27)
    \begin{flushright}
        {\footnotesize Produced with the SATM LaTeX template \MetOfficeVersionOnly}
    \end{flushright}
    \end{textblock}
}

