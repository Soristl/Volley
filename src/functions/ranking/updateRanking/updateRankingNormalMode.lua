function sessionRanking.update.normal()
  sessionRanking.ranks.normal = sessionRanking.cache.rebuild(sessionRanking.stats.normal, 'normal')
end
