\LoadClass[a4paper]{article}

% The version and date of this file
\newcommand\MetOfficeVersionOnly{v0.1.0}     
\newcommand\MetOfficeVersionDate{2013/10/16} 
\newcommand\MetOfficeVersionContact{ed.pavelin@metoffice.gov.uk}

\typeout{Using SATM LaTeX class: \MetOfficeVersionDate, \MetOfficeVersionOnly}
\typeout{All queries to: \MetOfficeVersionContact}

% Directory for images
\newcommand\ImageDir{/opt/ukmo/TeX/tex/latex/brand/v2.0.0/images}
\newcommand\IncludeDir{/opt/ukmo/TeX/tex/latex/brand/v2.0.0}

% We need LaTeX 2e or better
\NeedsTeXFormat{LaTeX2e}

% Required packages
\RequirePackage{ifthen}
\RequirePackage{fancyhdr}
\RequirePackage{color}
\RequirePackage{colortbl}
\RequirePackage{graphicx}
\RequirePackage{textpos}
\RequirePackage{setspace}
\RequirePackage{hyphenat}
\RequirePackage[english]{babel}

% Define boolean variables and processing options
%=================================================

% Protective Marking, there is no option to turn this on or off but it
% will activate itself if it finds the /marking command in the document
\newboolean{marked}
\setboolean{marked}{false}

% If preparing an external report this allows the customer's name to
% be inserted onto a legal disclaimer on the second page of the
% report
\newboolean{disclaimer}
\setboolean{disclaimer}{false}

% Black Cover - default will be white, note that this boolean
% works "backwards" due to the original implementation favouring
% the black cover as default
\newboolean{whitecover}
\setboolean{whitecover}{true}
\DeclareOption{whitecover}{
  \typeout{Option "whitecover": Using white cover pages}
  \setboolean{whitecover}{true}
}

% Printing layout
\newboolean{print}
\setboolean{print}{false}
\DeclareOption{print}{
  \typeout{Option "print": Setting alternating margins and fill pages}
  \setboolean{print}{true}
}

% Hadley Center Logo
\newboolean{hadley}
\setboolean{hadley}{false}
\DeclareOption{hadley}{
  \typeout{Option "hadley": Using Hadley Center logos}
  \setboolean{hadley}{true}
}

% "Basic" cover graphics (uses silhouette ripples instead of the funky
% 3d ones)
\newboolean{basic}
\setboolean{basic}{false}
\DeclareOption{basic}{
  \typeout{Option "basic": Using silhouette ripple graphics}
  \setboolean{basic}{true}
}

% Use RGB colors
\newboolean{rgb}
\setboolean{rgb}{false}
\DeclareOption{rgb}{
  \typeout{Option "rbg": Defining colors by rgb}
  \setboolean{rgb}{true}
}

% Hook for "english" option, which appears to be passed by default
% from Lyx, to stop the catch below from failing when using Lyx
\DeclareOption{english}{
  \typeout{Option "english": No action, placeholder for lyx usage}
}

% Catch unspecified options
\DeclareOption*{
\PackageError{MO}{Unknown option: ‘\CurrentOption’}
}

\ProcessOptions

% For print layout, set the geometry to twosided, resulting in
% alternating the margin widths to ensure the larger margin is always
% on the inside (for binding/stapling)
\ifthenelse{\boolean{print}}
{
  \usepackage[a4paper,hmargin={32mm,25mm},top=30mm,bottom=27mm,headheight=43pt,twoside]
  {geometry}
}{
  \usepackage[a4paper,hmargin={32mm,25mm},top=30mm,bottom=27mm,headheight=43pt]
  {geometry}
}

% Arial ( Helvetical) font
\renewcommand\sfdefault{phv} % Load helvetica for sans ser
\renewcommand\familydefault{\sfdefault} % Use sans serif by default

% Define Met Office colours using either RGB or CMYK
\ifthenelse{\boolean{rgb}}
{
  \definecolor{lime_green}   {rgb}{0.800000,1.00000,0.200000}
  \definecolor{midnight_blue}{rgb}{0.0117647,0.121569,0.450980}
  \definecolor{lilac}        {rgb}{0.560784,0.552941,0.796078}
  \definecolor{turquoise}    {rgb}{0.00000,0.678431,0.815686}
  \definecolor{moss_green}   {rgb}{0.529412,0.533333,0.00000}
  \definecolor{mustard}      {rgb}{0.843137,0.662745,0.00000}
  \definecolor{chocolate}    {rgb}{0.466667,0.290196,0.223529}
  \definecolor{grey}         {rgb}{0.611765,0.635294,0.600000 }
  \definecolor{light_grey}   {rgb}{0.83,0.84,0.83}
}{
  \definecolor{lime_green}   {cmyk}{0.20, 0.00, 1.00, 0.00}
  \definecolor{midnight_blue}{cmyk}{1.00, 0.95, 0.02, 0.10}
  \definecolor{lilac}        {cmyk}{0.52, 0.44, 0.00, 0.00}
  \definecolor{turquoise}    {cmyk}{0.98, 0.00, 0.11, 0.00}
  \definecolor{moss_green}   {cmyk}{0.25, 0.09, 0.10, 0.44}
  \definecolor{mustard}      {cmyk}{0.02, 0.24, 1.00, 0.08}
  \definecolor{chocolate}    {cmyk}{0.24, 0.75, 0.70, 0.64}
  \definecolor{grey}         {cmyk}{0.24, 0.11, 0.24, 0.33}
}

% Create a command which works like the author, date and title
% commands but allows the addition of a protective marking
\newcommand{\marking}[1]{
  \newcommand{\ProtectMark}{\Large{\textbf{#1}}}
  \setboolean{marked}{true}
}

% Create a command which allows you to specify your group
\newcommand{\SAGroup}[1]{
  \newcommand{\ResearchGroup}{\large{#1}}
}

% Create a command which allows you to specify the SATM number
\newcommand{\SATM}[1]{
  \newcommand{\SATMID}{\LARGE{Satellite Applications Technical Memo #1}}
}

% Create a command which works like the author, date and title
% commands but allows the addition of a customer + disclaimer
\newcommand{\disclaimer}[1]{
  \newcommand{\CustomerName}{#1}
  \setboolean{disclaimer}{true}
}

% Modify maketitle, causing it to create our new title page Note we
% force the page counter to start from -3, and the first document page
% to start from 1... Ensuring the toc processes don't get confused if
% we have the extra blank page (stars from -3 because the maximum
% possible number of title pages is 4 when using both the print option
% and providing a disclaimer)
\renewcommand{\maketitle}{    
  \setcounter{page}{-3}     
  \MOCover    
  \ifthenelse{\boolean{disclaimer}}
  {
    \MODisclaimer
  }{}
  \setcounter{page}{1}      
  \MOStyle                  
}

% End with the Met Office closing page
\AtEndDocument{
  \MOClosingPage
}

% Redefine pagestyle{plain} to use the Met Office style (this is used
% by Chapter & Section)
\fancypagestyle{plain}{
  \MOStyle
}

% Page Style
%============
\newcommand{\MOStyle}{

  % Basic page settings
  \pagecolor{white}
  \color{black}
  \pagestyle{fancy}
  \renewcommand{\headrulewidth}{0.1mm}
  \renewcommand{\footrulewidth}{0.1mm}
  \setstretch{1.5}

  % Select either standard or Hadley Center logo for right side of the header
  \fancyhead[R]{
    \begin{textblock}{10}(7,-1)
      \ifthenelse{\boolean{hadley}}
      {      
        \includegraphics[width=48mm]{\ImageDir/MOH_Landscape_B}
      }{
        \includegraphics[width=48mm]{\ImageDir/MO_Landscape_B}
      }
    \end{textblock}            
  }

  % Add copyright message to left side of footer
  \fancyfoot[L]{\hspace*{-0.05\textwidth}\
    \copyright\ Crown Copyright\ \number\year}

  % Depending on if a protective marking is being used...
  \ifthenelse{\boolean{marked}}
  {
    % Include the marking in the center, and page number on the right
    % of the footer, and in the header
    \fancyfoot[C]{\ProtectMark}
    \fancyfoot[R]{\thepage}
    \fancyhead[C]{\ProtectMark}
    \fancyhead[L]{}
  }{
    % Or just put the page number in the center
    \fancyfoot[C]{\thepage}
    \fancyfoot[R]{}
    \fancyhead[C]{}
    \fancyhead[L]{}
  }
}

% Disclaimer Page
% ===============
\newcommand{\MODisclaimer}{
	   \pagestyle{empty}
	   \input \IncludeDir/disclaimer.tex
           \ifthenelse{\boolean{marked}}
           {
             \pagestyle{fancy}
             \fancyfoot[C]{\ProtectMark}
             \fancyhead[C]{\ProtectMark}             
           }{}
	   \newpage
           % Add another blank page if using the print layout
           \pagecolor{white}
           \ifthenelse{\boolean{print}}{
             \thispagestyle{empty}
             \mbox{}
             \newpage
           }{}
	}

% Cover Page
% ============
\newcommand{\MOCover}{
  \thispagestyle{empty}

  % Set the colour of the page to white or black
  \ifthenelse{\boolean{whitecover}}
  {
    \pagecolor{white}
  }{
    \pagecolor{black}
  }

  % Apply protective markings to page, if requested. Set the colour of
  % the markings to white if the cover page is black
  \ifthenelse{\boolean{marked}}
  { 
    \thispagestyle{fancy}
    \renewcommand{\headrulewidth}{0.0pt}
    \ifthenelse{\boolean{whitecover}}
    {
      \fancyfoot[C]{\ProtectMark}
      \fancyhead[C]{\ProtectMark}
    }{
      \fancyfoot[C]{\textcolor{white}\ProtectMark}
      \fancyhead[C]{\textcolor{white}\ProtectMark}
    }
  }{}

  % 
  \setlength{\TPHorizModule}{10mm}
  \setlength{\TPVertModule}{10mm}

  % Add Ripple graphics, selecting the appropriate colour
  %\begin{textblock}{10}(-4,2)
  %  \ifthenelse{\boolean{basic}}{
  %    \ifthenelse{\boolean{whitecover}}{
  %      \includegraphics[height=220mm,width=240mm]{\ImageDir/MO_Ripples_Sil_W}
  %    }{
  %      \includegraphics[height=220mm,width=240mm]{\ImageDir/MO_Ripples_Sil_B}
  %    }
  %  }{
  %    \ifthenelse{\boolean{whitecover}}{
  %      \includegraphics[height=220mm,width=240mm]{\ImageDir/MO_Ripples_W}
  %    }{
  %      \includegraphics[height=220mm,width=240mm]{\ImageDir/MO_Ripples_B}
  %    }
  %  }
  %\end{textblock}

  % Add MO logo graphics, selecting appropriate colour and either
  % standard or Hadley Center
  \begin{textblock}{10}(-2.2,-1.9)
    \ifthenelse{\boolean{whitecover}}
    {
      \ifthenelse{\boolean{hadley}}
      {
        \includegraphics[width=36mm]{\ImageDir/MOH_Master_B} \\
      }{
        \includegraphics[width=36mm]{\ImageDir/MO_Master_B}\\
      }
    }{
      \ifthenelse{\boolean{hadley}}
      {
        \includegraphics[width=36mm]{\ImageDir/MOH_Master_W} \\
      }{
        \includegraphics[width=36mm]{\ImageDir/MO_Master_W}\\
      }
    }
  \end{textblock}

  \vspace{15mm}

  % Print the title, date and author information onto the cover in
  % appropriate colour. Note we explicitly set the white-cover case to
  % black as not doing so creates alignment issues between the
  % black/white versions
  \begin{textblock}{15}(-1.7,2.5)
    \hangindent=3pt  % I had to add this to get wrapped lines in the title to line up
                     % correctly (seems sort of dumb but I couldn't get it any other way)
    \setstretch{1.6}
    \ifthenelse{\boolean{whitecover}}
    {
      \noindent\textcolor{black}{
        \nohyphens{
          \begin{doublespace}
            \Huge\textbf\@title
            \vspace{10mm}\\\SATMID
            \vspace{15mm}\\\Large\@author
            \vspace{1mm}\\\ResearchGroup
            \vspace{15mm}\\\Large\@date
          \end{doublespace}
        }
      }
    }{
      \noindent\textcolor{white}{
        \nohyphens{
          \begin{doublespace}
            \Huge\textbf\@title
            \vspace{10mm}\\\SATMID
            \vspace{15mm}\\\Large\@author
            \vspace{1mm}\\\ResearchGroup
            \vspace{15mm}\\\Large\@date
          \end{doublespace}
        }
      }
    }   
  \end{textblock}

  % Onto the next page, insert and additional blank page if using the
  % print layout, and ensure the blank page is white regardless of the
  % title page colour
  \newpage
  \pagecolor{white}
  \ifthenelse{\boolean{print}}{
    \thispagestyle{empty}
    \mbox{}
    \newpage
  }{}
}

% Closing Page
%==============
\newcommand{\MOClosingPage}{
  \clearpage\newpage

  % If the document had an un-even page count this adds a blank fill
  % page to ensure the back cover page is on the back of the document
  % when printing double sided
  \ifthenelse{\boolean{print}}{
    \ifodd\thepage
    \centering
    This page is intentionally left blank
    \newpage
    \fi
  }{
  }

  \thispagestyle{empty}
  % Select the appropriate colour for the page and text depending on
  % the cover colour selected
  \ifthenelse{\boolean{whitecover}}{
    \vspace*{\fill}
    \begin{center}
      \begin{tabular}{ll}
        \textbf{Met Office}             &               Tel: 0370 900 0100\\
        FitzRoy Road, Exeter            &               Fax: 0370 900 5050\\
        Devon, EX1 3PB                  &               enquiries@metoffice.gov.uk\\
        UK                              &               www.metoffice.gov.uk\\
      \end{tabular}
    \end{center} 
    \begin{textblock}{7}(11.0,2.0)
      \footnotesize Produced with the SATM LaTeX template \MetOfficeVersionOnly
    \end{textblock}
  }{
    \pagecolor{black}
    \textcolor{white}{  \vspace*{\fill} 
      \begin{center} 
        \begin{tabular}{ll} 
          \textbf{Met Office}           &               Tel: 0370 900 0100\\ 
          FitzRoy Road, Exeter          &               Fax: 0370 900 5050\\ 
          Devon, EX1 3PB                &               enquiries@metoffice.gov.uk\\ 
          UK                            &               www.metoffice.gov.uk\\ 
        \end{tabular} 
      \end{center}
      \begin{textblock}{7}(11.0,2.0)
          \footnotesize Produced with the Met Office LaTeX template \MetOfficeVersionOnly
      \end{textblock}      
    }
  }
}
