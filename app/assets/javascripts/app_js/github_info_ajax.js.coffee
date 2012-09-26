pie.load ->
  # github commit 列表
  $github_page = jQuery('.page-github')
  $load = jQuery('.page-github .load')
  return if !$github_page.exists()
  return if !$load.exists()

  last_sha = $github_page.data('last_sha')
  first_sha = $github_page.data('first_sha')
  github_project_id = $github_page.data('github_project_id')

  jQuery.ajax
    type: 'GET'
    url: "/github_projects/#{github_project_id}/aj_show"
    data:
      last_sha : last_sha
      first_sha : first_sha
    success: (res)->
      $new = jQuery(res)
      $github_page.before($new).remove()     


pie.load ->
  # github user 信息
  $github_user_page = jQuery('.page-user-show')
  $load = jQuery('.page-user-show .load')

  return if !$github_user_page.exists()
  return if !$load.exists()


  user_id = $github_user_page.data('user_id')

  jQuery.ajax
    type: 'GET'
    url: "/users/#{user_id}/aj_github"
    success: (res)->
      $new = jQuery(res)
      $github_user_page.before($new).remove()


pie.load ->
  # github user gists
  $user_gists = jQuery('.page-user-gists')
  $load = jQuery('.page-user-gists .load')

  return if !$user_gists.exists()
  return if !$load.exists()

  user_id = $user_gists.data('user_id')

  jQuery.ajax
    type: 'GET'
    url: "/users/#{user_id}/aj_gists"
    success: (res)->
      $new = jQuery(res)
      $user_gists.before($new).remove()
