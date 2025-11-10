from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from db.database import get_db
from db.models import User, Holding
from core.security import get_current_user
from core.price_utils import load_prices as load_local_prices

router = APIRouter(prefix="/portfolio", tags=["Portfolio"])


@router.get("/")
def get_portfolio_summary(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """
    Get simplified portfolio summary for the current user.
    Returns each holding with symbol, units, average cost, current price, and unrealized P/L.
    """
    holdings = db.query(Holding).filter(Holding.user_id == current_user.id).all()
    prices_data = load_local_prices()

    total_value = 0.0
    total_gain = 0.0
    holding_list = []

    for holding in holdings:
        symbol = holding.instrument.symbol
        total_units = float(holding.total_units or 0)
        avg_cost = float(holding.average_cost or 0)
        current_price = prices_data.get(symbol)

        # Skip invalid holdings
        if current_price is None or total_units == 0:
            continue

        current_price = float(current_price)
        current_value = total_units * current_price
        invested_value = total_units * avg_cost
        unrealized_pl = current_value - invested_value

        total_value += current_value
        total_gain += unrealized_pl

        holding_list.append({
            "symbol": symbol,
            "units": round(total_units, 4),
            "avg_cost": round(avg_cost, 2),
            "current_price": round(current_price, 2),
            "unrealized_pl": round(unrealized_pl, 2)
        })

    return {
        "user_id": current_user.id,
        "holdings": holding_list,
        "total_value": round(total_value, 2),
        "total_gain": round(total_gain, 2)
    }


@router.get("/user/{user_id}")
def get_portfolio_summary_by_user_id(
    user_id: int,
    db: Session = Depends(get_db),
):
    """
    Get simplified portfolio summary for a specific user (no JWT required).
    """
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    holdings = db.query(Holding).filter(Holding.user_id == user_id).all()
    prices_data = load_local_prices()

    total_value = 0.0
    total_gain = 0.0
    holding_list = []

    for holding in holdings:
        symbol = holding.instrument.symbol
        total_units = float(holding.total_units or 0)
        avg_cost = float(holding.average_cost or 0)
        current_price = prices_data.get(symbol)

        if current_price is None or total_units == 0:
            continue

        current_price = float(current_price)
        current_value = total_units * current_price
        invested_value = total_units * avg_cost
        unrealized_pl = current_value - invested_value

        total_value += current_value
        total_gain += unrealized_pl

        holding_list.append({
            "symbol": symbol,
            "units": round(total_units, 4),
            "avg_cost": round(avg_cost, 2),
            "current_price": round(current_price, 2),
            "unrealized_pl": round(unrealized_pl, 2)
        })

    return {
        "user_id": user_id,
        "holdings": holding_list,
        "total_value": round(total_value, 2),
        "total_gain": round(total_gain, 2)
    }