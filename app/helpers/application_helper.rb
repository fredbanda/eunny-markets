module ApplicationHelper
  def title
    if content_for?(:title)
      "#{content_for(:title)} | #{t("eunny-markets")}"
    else
      t("eunny-markets")
    end
  end
end
