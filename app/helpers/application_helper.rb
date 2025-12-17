module ApplicationHelper
    def check_cart
        if session["cart"].present?
        else
            session["cart"] = {
                "products" => [],
                "coupons" => [],
                "total" => 0,
            }
        end
    end
end
