# frozen_string_literal: true

module ApplicationHelper

  def title(page_title)
    content_for(:title) { page_title }
  end
  
  def yesno(f)
    (f ? '<span class="yes">Yes</span>' : '<span class="no">No</span>').html_safe
  end

end
