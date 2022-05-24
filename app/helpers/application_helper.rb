module ApplicationHelper
  def full_title(page_title, base_title = '系统')
    if page_title.empty?
      base_title
    else
      "#{page_title} - #{base_title}"
    end
  end
  def notice_message
    alert_types = { notice: :success, alert: :danger }

    close_button_options = { class: "close", "data-dismiss" => "alert", "aria-hidden" => true }
    close_button = content_tag(:button, "×", close_button_options)

    alerts = flash.map do |type, message|
      alert_content = close_button + message

      alert_type = alert_types[type.to_sym] || type
      alert_class = "alert alert-#{alert_type} alert-dismissable"

      content_tag(:div, alert_content, class: alert_class)
    end

    alerts.join("\n").html_safe
  end
  def main_nav
    nav_html = %Q[
      <li class="#{'active' if controller_name == 'dashboard'}">#{link_to '控制面板', root_path}</li>
      <li class="#{'active' if (['accounts', 'download_logs', 'import_logs'].include? controller_name) || (controller_name == 'informations' && params[:new_import].present? && params[:list2].nil?)}">#{link_to '帐号列表', accounts_path}</li>
      <li class="#{'active' if  ([ "abnormals", "platforms" ].include? controller_name)  || (controller_name == 'informations' && params[:new_import].nil?  && params[:list2].nil?) }">#{link_to '导入数据', informations_path}</li>
      <li class="#{'active' if  ([ "abnormals", "platforms" ].include? controller_name)  || (controller_name == 'informations' && params[:new_import].nil?  && params[:list2].present?) }">#{link_to '导入数据2', informations_path(list2: true)}</li>
      <li class="#{'active' if  ["upload_files" ].include? controller_name }">#{link_to '导入文件', upload_files_path}</li>
    ]

    nav_html
  end

  def side_nav
    if (['accounts', 'download_logs', 'import_logs'].include? controller_name) ||( controller_name == 'informations' && params[:new_import].present? && params[:list2].nil?)
      nav_html = %Q[
        <li class="#{'active' if controller_name == 'accounts' && ( (params[:is_normal].nil? ||  params[:is_normal] == "true") && params[:is_meng_gu].nil? ) }">#{link_to "正常帐号", accounts_path}</li>
        <li class="#{'active' if controller_name == 'accounts' && ( params[:is_normal].present? ||  params[:is_normal] == "false" )}">#{link_to "不正常帐号", accounts_path(is_normal: false)}</li>
        <li class="#{'active' if controller_name == 'accounts' && ( params[:is_meng_gu] == "true" ) }">#{link_to "蒙古正常帐号", accounts_path(is_meng_gu: true)}</li>
        <li class="#{'active' if controller_name == 'download_logs' && params[:is_meng_gu].nil? }">#{link_to "导出数量记录", download_logs_path}</li>
        <li class="#{'active' if controller_name == 'download_logs' && params[:is_meng_gu].present?  }">#{link_to "蒙古导出数量记录", download_logs_path(is_meng_gu: true)}</li>
        <li class="#{'active' if controller_name == 'import_logs' }">#{link_to "设备成功数量", import_logs_path}</li>
        <li class="#{'active' if controller_name == 'informations' && params[:new_import].present?}">#{link_to "获取二维码帐号列表", informations_path(new_import: true)}</li>
      ]
    elsif ([ "abnormals", "platforms" ].include? controller_name) || controller_name == 'informations' && params[:new_import].nil? && params[:list2].nil?
      nav_html = %Q[
        <li class="#{'active' if controller_name == 'informations' &&  params[:new_import].nil? && params[:list2].nil? } ">#{link_to "导入数据", informations_path}</li>
        <li class="#{'active' if controller_name == 'abnormals'}">#{link_to "异常号码", abnormals_path}</li>
        <li class="#{'active' if controller_name == 'platforms'}">#{link_to "东帝汶号码", platforms_path}</li>
      ]
    elsif controller_name == 'informations' && params[:new_import].nil? &&  params[:list2].present?
      nav_html = %Q[
        <li class="#{'active' if controller_name == 'informations' &&  params[:new_import].nil? && params[:list2].present? } ">#{link_to "导入数据2", informations_path(list2: true)}</li>
      ]
    elsif ["upload_files"].include? controller_name
      nav_html = %Q[
        <li class="#{'active' if controller_name == 'upload_files' && (params[:type] != "txt")}">#{link_to "上传系统文件", upload_files_path}</li>
        <li class="#{'active' if controller_name == 'upload_files' && (params[:type] == "txt")}">#{link_to "上传脚本配置文件", upload_files_path(type: "txt")}</li>
      ]
    else controller_name == 'dashboard'
      nav_html = %Q[
        <li class="#{'active' if controller_name == 'dashboard'}">#{link_to "控制面板", root_path}</li>
      ]
    end
    nav_html
  end
end
