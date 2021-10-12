# frozen_string_literal: true

ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  content title: proc { I18n.t('active_admin.dashboard') } do
    panel 'BI: Daily Performance ($)' do
      # Defines CTE alias
      # cte_table = Arel::Table.new(:cte_table)
      # # Adds alias to subquery
      # composed_cte = Arel::Nodes::As.new(
      #   cte_table,
      #   Arel.sql(
      #     format(
      #       '(%s)',
      #       TradeEntry
      #         .closed
      #         .group("DATE_TRUNC('day', created_at)")
      #         .select("sum(amount) as sum, DATE_TRUNC('da")
      #         .to_sql,
      #     ),
      #   ),
      # )
      # TODO(DZ): Make this arel instead
      sql = <<-SQL
        with data as (
          select
            DATE_TRUNC('day', created_at) as day,
            SUM(true_profit) as true_profit
          from trade_entries
          where status = 'closed'
          and paper = false
          group by 1
        )

        select
          day,
          sum(true_profit) over (
            order by day asc rows between unbounded preceding and current row
          )
        from data
      SQL

      line_chart ActiveRecord::Base.connection.execute(sql).map(&:values)
    end
  end
end
