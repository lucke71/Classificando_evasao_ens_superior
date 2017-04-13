\name{create_dropout_database}
\alias{create_dropout_database}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
Creates databases to classify dropout students
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
Creates the databases that should be used to classify the dropout students of Brazil`s higher education students.
}
\usage{
create_dropout_database(co_ies, tipo_evasao)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{co_ies}{
%%     ~~Describe \code{co_ies} here~~
numeric vector containing the institutions codes
}
  \item{tipo_evasao}{
%%     ~~Describe \code{tipo_evasao} here~~
A string specifying which level of dropout is to be generated. Possible values are: "curso", "ies" and "grupo".
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~

}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
dataframe
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
create_dropout_database(co_ies=2,tipo_evasao="curso")

create_dropout_database(co_ies=c(415,15001,55),tipo_evasao="ies")
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
