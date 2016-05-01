# Jekyll::Paginate::Multiple

Uses jekyll-paginate for the pagination, but allows to paginate multiple blogs.


## Installation

    gem install jekyll-paginate-multiple

## Usage

The posts of the different blogs must be in their own directories in `_posts/`.
Each directory has it's own pagination configuration.

### Config example

Example of `_config.yml` file:

### Pagination
    paginate_multiple:
      - paginate: 10
        paginate_path: '/blog/page:num/'
        sub_dir: '/en'
      - paginate: 10
        paginate_path: '/blog/de/page:num/'
        sub_dir: '/de'

### Plugins
    gems :
      - jekyll-paginate
      - jekyll-paginate-multiple

## Licence

MIT.