\name{hashtags_table}
\alias{hashtags_table}
\title{Top hashtags data frame}
\usage{
hashtags_table(df, top_n = 10)
}
\description{
This function retrives top features hashtags.
}
\arguments{
  \item{df}{The preprocessed twetter data}

  \item{hashtag_remove}{hashtag to remove}

  \item{top_n}{top n keywords}

}

\examples{
df_pre <- twitter_preprocess(twitter_df, ud_lang = "spanish", stopwords_lang = "es")
hashtags_table(df, hashtag_remove = "#cultura", top_n = 10)
}
\source{
Benoit et al (2018) quanteda: An R package for the quantitative analysis of textual data
}
