\name{topic_radarmap}
\alias{topic_radarmap}
\title{Topic distribution by year}
\usage{
topic_radarmap(mallet_df,df , col = "royalblue")
}
\description{
This function display word term plot of topics.
}
\arguments{
  \item{mallet_df}{mallet topic model}

  \item{df}{preprocessed twitter data}

  \item{col}{"royalblue", "tomato", "#B4CF68", "green", "purple", "orange","grey","red","#8DD3C7" , "pink", "blue","gold"}
}

\examples{

df_pre <- twitter_preprocess(df_tweets, ud_lang = "spanish", stop_words)
df_topics <- twitter_topic(df_pre, n_topic = 7)
topic_radarmap(df_topics, df_pre , col = "royalblue")

}
