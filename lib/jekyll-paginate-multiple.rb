require 'jekyll'

module Jekyll
  module Paginate
    module Multiple

      class MultiplePagination < Jekyll::Paginate::Pagination
        safe true
        priority :lowest

        # Generate paginated pages for multiple sub directories.
        #
        # Example config:
        #
        #   paginate_multiple:
        #     - paginate: 10
        #       paginate_path: '/blog/page:num/'
        #       sub_dir: '/en'
        #     - paginate: 10
        #       paginate_path: '/blog/de/page:num/'
        #       sub_dir: '/de'
        #
        # site - The Site.
        #
        # Returns nothing
        def generate(site)
          paginate_multiple = site.config['paginate_multiple']

          unless paginate_multiple.nil?
            if paginate_multiple.kind_of?(Array)

              # save original paginate and paginate_path so they can be restored
              original_paginate = site.config['paginate']
              original_paginate_path = site.config['paginate_path']

              paginate_multiple.each_with_index do |pagination, index|
                paginate = pagination['paginate']
                paginate_path = pagination['paginate_path']
                sub_dir = pagination['sub_dir']
                
                if paginate && paginate_path && sub_dir
                  # set paginate and paginate_path for each entry for the Jekyll::Paginate::Pager
                  site.config['paginate'] = paginate
                  site.config['paginate_path'] = paginate_path

                  template = template_page(site)

                  if template
                    posts = posts_for_sub_dir(site, sub_dir)
                    paginate(site, template, posts, paginate)
                  else
                    Jekyll.logger.warn 'Pagination Multiple:', "Cannot find an index.html to use as the" +
                        "pagination template for pagination path: '#{pagination['paginate_path']}'. "
                        "Skipping pagination for entry #{index}."
                  end
                else
                  Jekyll.logger.warn 'Pagination Multiple:', "For each 'pagination_multiple' entry, 'paginate', " +
                      "'paginate_path' and 'sub_dir' must be set. Skipping pagination for entry #{index}."
                end
              end

              # restore original paginate and paginate_path
              site.config['paginate_path'] = original_paginate_path
              site.config['paginate'] = original_paginate

            else
              Jekyll.logger.warn 'Pagination Multiple:', "Config parameter 'pagination_multiple' must be an array. " +
                  "Skipping pagination."
            end

          end
        end

        # Returns all the posts in a given sub directory.
        #
        # site - The Site.
        # sub_dir - The sub directory of the posts.
        #
        # Returns the posts in the sub directory
        def posts_for_sub_dir(site, sub_dir)
          site.site_payload['site']['posts'].reject{ |post| !post_is_in_sub_dir(post, sub_dir) || post['hidden'] }
        end

        # Paginates blog posts with a given page template.
        #
        # site - The Site.
        # template - The template page for the pagination.
        # posts - All the posts that should be paginated for the template.
        # posts_per_page - Number of posts a page should have.
        #
        # Returns nothing
        def paginate(site, template, posts, posts_per_page)
          total_pages = Pager.calculate_pages(posts, posts_per_page.to_i)
          (1..total_pages).each do |page_num|
            current_page = page_num > 1 ? create_page(site, template, page_num) : template
            pager = Pager.new(site, page_num, posts, total_pages)
            current_page.pager = pager
          end
        end

        # Creates a paginated page from a given template.
        #
        # site - The Site.
        # template - The template page.
        # page_num - The page number.
        #
        # Returns the created page
        def create_page(site, template, page_num)
          page = Page.new(site, site.source, template.dir, template.name)
          page.dir = Pager.paginate_path(site, page_num)
          site.pages << page
          page
        end

        # Checks whether a post is in a given sub directory in '_posts'.
        #
        # post - The post.
        # sub_dir - The sub directory
        #
        # Returns true if the post is in the sub directory, false otherwise
        def post_is_in_sub_dir(post, sub_dir)
          sub_dir = ensure_leading_slash(sub_dir)
          sub_dir = ensure_no_trailing_slash(sub_dir)

          posts_dir = '_posts'
          post_path = post.relative_path

          post_sub_dir = post_path[posts_dir.length..post.relative_path.rindex('/')-1]

          sub_dir == post_sub_dir
        end

        # Ensures a directory has a leading slash.
        #
        # dir - The directory.
        #
        # Returns the directory with a leading slash
        def ensure_leading_slash(dir)
          dir[0] == '/' ? dir : '/' + dir
        end

        # Ensures a directory has no trailing slash.
        #
        # dir - The directory.
        #
        # Returns the directory with no trailing slash
        def ensure_no_trailing_slash(dir)
          dir[-1] != '/' ? dir : dir[0..-2]
        end

      end

    end
  end
end
