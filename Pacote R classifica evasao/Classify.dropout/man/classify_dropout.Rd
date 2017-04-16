\name{classify_dropout}
\alias{classify_dropout}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
Transforms dataframe and classifies data using multiple classifiers.
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
This function transforms data created by "create_dropout_database" and classifies dropout students according to the users choosing. 
}
\usage{
classify_dropout(database, cv_folds = 4, pct_training = 0.75, classifier = "CART", num_cores = 4, balance = "no")
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{database}{
%%     ~~Describe \code{database} here~~
Dataframe that contains student data named according to "create_dropout_database".
}
  \item{cv_folds}{
%%     ~~Describe \code{cv_folds} here~~
Number of folds to be used in cross-validation. Only numbers greater than 0 (zero).
}
  \item{pct_training}{
%%     ~~Describe \code{pct_training} here~~
Percentage of the original database to be used for training the classifiers. Only numbers between 0 and 1 are accepted.
}
  \item{classifier}{
%%     ~~Describe \code{classifier} here~~
String contaning the name of classifier to be used. Options are "CART", "C45", "Nnet", "reglog", "NB" and "all". See details.
}
  \item{num_cores}{
%%     ~~Describe \code{num_cores} here~~
Number of cpu machine cores to be used. Only works when runnning R in a Unix system.
}
  \item{balance}{
%%     ~~Describe \code{balance} here~~
String containing the name of the technique to balance data. Options are "up", "down" and "no". See details.
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
The CART classifier is called from the caret's package using the "rpart" method with maximum depth of 30 and tune length equal to 10.
The C4.5 classifier (C45) is called from the caret's package using the "J48" method with tune length equal to 10.
The neural net classifier (Nnet) is called from the caret's package using the "nnet" method with maximum iterations equal to 1000.
The logistic regression classifier (reglog) is called from the caret's package using the "glm" method and the "logit" link.
The naive bayes classifier (NB) is called from the caret's package using the "nb" method.
All classifiers are using the specificity metric to find the best fitting model.

For the balancing, simple random sample is used to down sample the data to the same amount of dropout students. For up-sampling, simple random sampling with replacement of dropout students is used to add to the original data.
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
\item{cart_fit}{A list of class train. It only appears if the CART classifier was selected. See Caret package for more details on the class.}
\item{cart_pred}{A factor with the predictions for the test data using the best CART model based on specificity.}
\item{mc_cart}{Confusion matrix for the CART predictions on the test data.}
\item{C45_fit}{A list of class train. It only appears if the C4.5 classifier was selected. See Caret package for more details on the class.}
\item{C45_pred}{A factor with the predictions for the test data using the best C4.5 model based on specificity.}
\item{mc_C45}{Confusion matrix for the C4.5 predictions on the test data.}
\item{nnet_fit}{A list of class train. It only appears if the neural net classifier was selected. See Caret package for more details on the class.}
\item{nnet_pred}{A factor with the predictions for the test data using the best neural net model based on specificity.}
\item{mc_nnet}{Confusion matrix for the neural net predictions on the test data.}
\item{reglog_fit}{A list of class train. It only appears if the logistic regression classifier was selected. See Caret package for more details on the class.}
\item{reg_pred}{A factor with the predictions for the test data using the best logistic regression model based on specificity.}
\item{mc_reg}{Confusion matrix for the logistic regression predictions on the test data.}
\item{naive_fit}{A list of class train. It only appears if the naive bayes classifier was selected. See Caret package for more details on the class.}
\item{naive_pred}{A factor with the predictions for the test data using the best naive bayes model based on specificity.}
\item{mc_naive}{Confusion matrix for the naive bayes predictions on the test data.}

}
\references{
%% ~put references to the literature/web site here ~
http://topepo.github.io/caret/training.html
Kuhn (2008), “Building Predictive Models in R Using the caret” (http://www.jstatsoft.org/article/view/v028i05/v28i05.pdf)
}
\author{
%%  ~~who you are~~
Lucas Assis
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
\code{\link[caret]{train}}
\code{\link[Classify.dropout]{create_dropout_database}}
}
\examples{
# CART example
library(Classify.dropout)
data(db_example)
classify_dropout(db_example)
cart_fit$finalModel
mc_cart

% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
%\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
%\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
