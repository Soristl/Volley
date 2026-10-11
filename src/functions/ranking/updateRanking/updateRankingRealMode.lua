function sessionRanking.update.real()
  sessionRanking.ranks.real = sessionRanking.cache.rebuild(sessionRanking.stats.real, 'real')
end
