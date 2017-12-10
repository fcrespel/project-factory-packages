class HooksController < ApplicationController
    layout 'admin'

    before_filter :require_admin
    before_filter :find_placeholder
    before_filter :load_hooks, :except => :load
    before_filter :load_tree, :except => :load

    def index
        @hook = Hook.find_by_hook(@placeholder[:hook].to_s) || Hook.new(:hook => @placeholder[:hook].to_s)
    end

    def load
        if @placeholder
            @hook = Hook.find_by_hook(@placeholder[:hook].to_s)
            respond_to do |format|
                format.html do
                    redirect_to(:action => 'index', :hook => @placeholder[:hook])
                end
                format.js do
                    if Rails::VERSION::MAJOR >= 3 && Rails::VERSION::MINOR >= 1
                        render('load')
                    else
                        render(:update) do |page|
                            if @placeholder[:outline]
                                page.replace_html('outline', :partial => "placeholders/#{@placeholder[:outline]}", :locals => { :hook => @placeholder[:hook] })
                            else
                                page.replace_html('outline', :partial => "placeholders/none")
                            end
                            page.replace_html('form-content', :partial => 'form')
                        end
                    end
                end
            end
        else
            redirect_to(:action => 'index')
        end
    end

    def tree
        @hook = Hook.find_by_hook(@placeholder[:hook].to_s) || Hook.new(:hook => @placeholder[:hook].to_s)
        respond_to do |format|
            format.html do
                redirect_to(params.merge(:action => 'index'))
            end
            format.js do
                if Rails::VERSION::MAJOR >= 3 && Rails::VERSION::MINOR >= 1
                    render('tree')
                else
                    render(:update) do |page|
                        page.replace_html('hooks-list', :partial => 'list')
                    end
                end
            end
        end
    end

    def update
        if params[:hook]
            @hook = Hook.find_by_hook(params[:hook])
            if @hook
                if params[:html_code].blank?
                    if @hook.destroy
                        flash.now[:notice] = l(:notice_successful_delete)
                        @hook = nil
                    end
                else
                    if @hook.update_attributes(:html_code => params[:html_code])
                        flash.now[:notice] = l(:notice_successful_update)
                    end
                end
            else
                @hook = Hook.new(:hook => params[:hook], :html_code => params[:html_code])
                if @hook.save
                    flash.now[:notice] = l(:notice_successful_create)
                end
            end
        end
        render(:action => 'index')
    end

private

    def find_placeholder
        @placeholder = HooksManager::Placeholders[params[:hook].to_sym] if params[:hook]
        true
    end

    def load_hooks
        @hooks = {}
        Hook.all.each do |hook|
            @hooks[hook.hook.to_sym] = hook
        end
        true
    end

    def load_tree
        parse_tree_parameters
        @tree = HooksManager::Placeholders.tree(@by, @all)
        unless @placeholder
            first = @tree.keys.sort.first
            second = @tree[first].keys.sort.first
            @placeholder = @tree[first][second].first[1]
        end
        true
    end

    def parse_tree_parameters
        if params[:by]
            @by = params[:by] == 'location' ? :location : :page
            session[:hooks] ||= {}
            session[:hooks][:by] = @by
        else
            @by = session[:hooks] && session[:hooks][:by] ? session[:hooks][:by] : :page
        end
        if params[:all]
            @all = params[:all] && params[:all].to_i > 0
            session[:hooks] ||= {}
            session[:hooks][:all] = @all
        else
            @all = session[:hooks] && session[:hooks][:all] ? session[:hooks][:all] : false
        end
    end

end
