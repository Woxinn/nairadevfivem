Logs = {}
function Logs.Discord(title, description)
  if not Config.DiscordLogs.Enabled or Config.DiscordLogs.Webhook == '' then return end
  PerformHttpRequest(Config.DiscordLogs.Webhook, function() end, 'POST', json.encode({username=Config.DiscordLogs.BotName, avatar_url=Config.DiscordLogs.Avatar, embeds={{title=title, description=description, color=5814783}}}), {['Content-Type']='application/json'})
end
