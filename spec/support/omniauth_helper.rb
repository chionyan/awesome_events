def log_in_as(user)
  OmniAuth::AuthHash.new(
    provider: user.provider,
    uid: user.uid,
    info: {
      nickname: user.nickname,
      image: user.image_url,
    },
  )
end
