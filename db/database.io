Table Posts {
  id integer
  user_id integer
  description string
  updated_at timestamp
  created_at timestamp
}

Table Users {
  id integer [primary key]
  username varchar
  avatar string
  email string
  firstname varchar
  lastname varchar
  updated_at timestamp
  created_at timestamp
}

Table Comments {
  id integer
  post_id integer
  user_id integer
  text string
  created_at timestamp
  updated_at timestamp
}

Table Reactions {
  id integer
  post_id integer
  user_id integer
  created_at timestamp
  updated_at timestamp
}

Table Subscribers {
  user_id integer
  subscribe_id integer
  created_at timestamp
  updated_at timestamp
}

Table Media {
  id integer
  url string
  created_at timestamp
  updated_at timestamp
}

Table Post_media {
  post_id integer
  media_id integer
  created_at timestamp
  updated_at timestamp
}

Ref: Posts.user_id > Users.id // many-to-one
Ref: Comments.user_id > Users.id
Ref: Reactions.user_id > Users.id
Ref: Subscribers.user_id > Users.id

Ref: Comments.post_id > Posts.id
Ref: Reactions.post_id > Posts.id
Ref: Post_media.post_id > Posts.id

Ref: Users.id - Subscribers.subscribe_id
Ref: Media.id - Post_media.media_id


