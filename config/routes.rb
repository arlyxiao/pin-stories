# -*- coding: utf-8 -*-
MindpinAgile::Application.routes.draw do  
  # -- 用户登录认证相关 --
  root :to => 'index#index'
  
  get  '/login'  => 'sessions#new'
  post '/login'  => 'sessions#create'
  get  '/logout' => 'sessions#destroy'
  
  # get  '/signup'        => 'signup#form'
  # post '/signup_submit' => 'signup#form_submit'
  
  # -- 以下可以添加其他 routes 配置项
  
  # -- 管理员界面
  
  namespace :admin do
    get  '/'         => 'admin#members'
    get  '/members'  => 'admin#members'
    
    get  '/members/new' => 'admin#new_member'
    post '/members'     => 'admin#create_member'
    
    get  '/members/:id/edit' => 'admin#edit_member'
    put  '/members/:id'      => 'admin#update_member'
  end

  get '/atme/:name' => 'atme#atme'

  resources :users do
    member do
      get :github
      get :aj_github
      get :gists
      get :aj_gists
    end

    resources :issues, :controller => :user_issues do
      collection do
        get :assigned, :action => :index_assigned
      end
    end
    resources :ideas,  :controller => :user_ideas


  end
  
  # --------
  
  resources :products do
    resources :stories,    :shallow => true
    resources :issues,     :shallow => true do
      collection do
        get :closed, :action => :index_closed
        get :pause,  :action => :index_pause
      end
    end
    resources :streams,    :shallow => true
    resources :lemmas,     :shallow => true
    resources :activities, :shallow => true
    resources :milestones, :shallow => true
    resources :github_projects,    :shallow => true
  end

  resources :milestones do
    resources :usecases, :shallow => true
    resources :milestone_reports, :shallow => true
  end

  resources :github_projects do
    member do
      get :next_page
      get :prev_page
      get :aj_show
    end
  end

  
  post '/milestone_reports/:id/create_issue' => 'milestone_reports#create_issue'

  resources :issues, :only => [:show, :edit, :update, :destroy] do
    member do
      put :close
      put :reopen
      put :pause

      get :assign_users
      put :do_assign_users
      put :receive
      put :change_state
    end
  end

  resources :stories, :only => [:show, :edit, :update, :destroy] do
    collection do
      post  :save_draft
      get  :mine
      get  :search_mine
    end

    member do
      get :assign_streams
      put :do_assign_streams
      get :assign_users
      put :do_assign_users
      put :change_status
      post :save_to_wiki

      get :versions
      put 'rollback/:version', :action => :rollback
    end
  end

  resources :ideas do
    collection do
      post :create_for_story
      get  :mine
    end
  end

  # ---------------
  # WIKI 相关
  scope '/products/:product_id' do
    # wiki
    scope '/wiki/:title' do
      get '/' => 'wiki#show'
      put '/' => 'wiki#update'
      delete '/' => 'wiki#destroy'

      get '/edit' => 'wiki#edit'
      get '/versions' => 'wiki#versions'
      put '/rollback/:version' => 'wiki#rollback'


      get '/edit_section'   => 'wiki#edit_section'
      put '/update_section' => 'wiki#update_section'

      get '/refs'  => 'wiki#refs'
    end

    # wiki
    get  '/wiki' => 'wiki#index'
    post '/wiki' => 'wiki#create'
    get  '/wiki_new' => 'wiki#new'
    post '/wiki_preview' => 'wiki#preview'
    get  '/wiki_orphan'  => 'wiki#orphan'
    get  '/wiki_search'  => 'wiki#search'

    # wiki evernote
    get  '/wiki_evernote_connect'       => 'evernote#connect'
    get  '/wiki_evernote_callback'      => 'evernote#callback'
    get  '/wiki_evernote_import'        => 'evernote#import'
    post '/wiki_evernote_confirmimport' => 'evernote#confirm_import'
    post '/wiki_evernote_doimport'      => 'evernote#do_import'

    # story 全文搜索
    get  '/stories_search' => 'stories#search'

  end

  # # wiki  draft
  post '/wiki_save_draft' => 'wiki#save_draft'
  get '/wiki_get_draft' => 'wiki#get_draft'
  
  resources :drafts
  resources :http_apis



  resources :work_results do
    collection do
      get :next
      get :tag
    end
  end
  get '/tags/*path' => 'tags#list_by_tag'

  # ----------------------

  # 所有类型的评论都在这里，不单独定义
  resources :comments do
    collection do
      get :show_model_comments
      get :received # 我收到的评论
    end
  end

  resources :user_assigns do
    collection do
      post :assign_to_me # 领取待分配对象
    end
  end

  # 快速提交 agile 的 bug
  post '/create_agile_issue' => 'index#create_agile_issue'

  # 检查各种统计
  get '/check_tip_messages' => 'index#check_tip_messages'
  
  resources :model_attaches
end
