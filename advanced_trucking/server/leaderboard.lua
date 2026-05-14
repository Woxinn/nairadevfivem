Leaderboard = {}
function Leaderboard.GetTop() return MySQL.query.await('SELECT name, total_earnings, completed_deliveries, reputation, total_distance, perfect_deliveries, weekly_earnings FROM advanced_trucking_profiles ORDER BY total_earnings DESC LIMIT 25') end
