
api_user = DryAuth::User.create! username: 'pbx-user-max', email: 'api-pbx-max@example.com', password: '62946294'
api_user.add_role :api
api_user.save # generate authentication_token  after role is assigned

