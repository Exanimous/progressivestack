# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://progressivestack.com"

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.

  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host

  # Usage: add(path, options={})
  #        (default options are used if you don't specify)

  add home_path, changefreq: 'weekly', priority: 1.0
  add quota_path, changefreq: 'daily', priority: 1.0

  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end

  #  CaseStudy.find_each do |case_study|
  #    add case_study_path(case_study.slug), lastmod: case_study.updated_at, changefreq: 'never'
  #  end
end
