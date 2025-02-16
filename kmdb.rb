
ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS performances")
ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS movies")
ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS studios")
ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS actors")


ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: "kmdb.sqlite3"
)


class Movie < ActiveRecord::Base
  belongs_to :studio
  has_many :performances
  has_many :actors, through: :performances
end

class Studio < ActiveRecord::Base
  has_many :movies
end

class Actor < ActiveRecord::Base
  has_many :performances
  has_many :movies, through: :performances
end

class Performance < ActiveRecord::Base
  belongs_to :movie
  belongs_to :actor
end


ActiveRecord::Schema.define do
  create_table :studios do |t|
    t.string :name
  end

  create_table :movies do |t|
    t.string :title
    t.integer :year
    t.string :rating
    t.integer :studio_id
  end

  create_table :actors do |t|
    t.string :name
  end

  create_table :performances do |t|
    t.integer :movie_id
    t.integer :actor_id
    t.string :character_name
  end
end


studio = Studio.create(name: "Warner Bros.")


batman_begins = Movie.create(
  title: "Batman Begins",
  year: 2005,
  rating: "PG-13",
  studio_id: studio.id
)

dark_knight = Movie.create(
  title: "The Dark Knight",
  year: 2008,
  rating: "PG-13",
  studio_id: studio.id
)

dark_knight_rises = Movie.create(
  title: "The Dark Knight Rises",
  year: 2012,
  rating: "PG-13",
  studio_id: studio.id
)


christian_bale = Actor.create(name: "Christian Bale")
michael_caine = Actor.create(name: "Michael Caine")
liam_neeson = Actor.create(name: "Liam Neeson")
katie_holmes = Actor.create(name: "Katie Holmes")
gary_oldman = Actor.create(name: "Gary Oldman")
heath_ledger = Actor.create(name: "Heath Ledger")
aaron_eckhart = Actor.create(name: "Aaron Eckhart")
maggie_gyllenhaal = Actor.create(name: "Maggie Gyllenhaal")
tom_hardy = Actor.create(name: "Tom Hardy")
joseph_gordon_levitt = Actor.create(name: "Joseph Gordon-Levitt")
anne_hathaway = Actor.create(name: "Anne Hathaway")


Performance.create([
  { movie_id: batman_begins.id, actor_id: christian_bale.id, character_name: "Bruce Wayne" },
  { movie_id: batman_begins.id, actor_id: michael_caine.id, character_name: "Alfred" },
  { movie_id: batman_begins.id, actor_id: liam_neeson.id, character_name: "Ra's Al Ghul" },
  { movie_id: batman_begins.id, actor_id: katie_holmes.id, character_name: "Rachel Dawes" },
  { movie_id: batman_begins.id, actor_id: gary_oldman.id, character_name: "Commissioner Gordon" },
  { movie_id: dark_knight.id, actor_id: christian_bale.id, character_name: "Bruce Wayne" },
  { movie_id: dark_knight.id, actor_id: heath_ledger.id, character_name: "Joker" },
  { movie_id: dark_knight.id, actor_id: aaron_eckhart.id, character_name: "Harvey Dent" },
  { movie_id: dark_knight.id, actor_id: michael_caine.id, character_name: "Alfred" },
  { movie_id: dark_knight.id, actor_id: maggie_gyllenhaal.id, character_name: "Rachel Dawes" },
  { movie_id: dark_knight_rises.id, actor_id: christian_bale.id, character_name: "Bruce Wayne" },
  { movie_id: dark_knight_rises.id, actor_id: gary_oldman.id, character_name: "Commissioner Gordon" },
  { movie_id: dark_knight_rises.id, actor_id: tom_hardy.id, character_name: "Bane" },
  { movie_id: dark_knight_rises.id, actor_id: joseph_gordon_levitt.id, character_name: "John Blake" },
  { movie_id: dark_knight_rises.id, actor_id: anne_hathaway.id, character_name: "Selina Kyle" }
])


puts "Movies"
puts "======"
puts ""


Movie.all.order(:year).each do |movie|
  puts "#{movie.title.ljust(20)} #{movie.year}  #{movie.rating.ljust(6)} #{movie.studio.name}"
end


puts ""
puts "Top Cast"
puts "========"
puts ""


Performance.all.includes(:movie, :actor).order('movies.title, performances.character_name').each do |performance|
  puts "#{performance.movie.title.ljust(20)} #{performance.actor.name.ljust(20)} #{performance.character_name}"
end
