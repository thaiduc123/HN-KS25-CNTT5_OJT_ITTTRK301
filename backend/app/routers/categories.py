from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app.db.session import get_db
from app.models.category import Category
from app.models.dish import Dish
from app.schemas.category import (
    CategoryCreate,
    CategoryUpdate,
    CategoryStatusUpdate,
    CategoryReorder,
    CategoryOut,
)

router = APIRouter(
    prefix="/categories",
    tags=["Categories"]
)


# 1. Lấy danh sách danh mục
@router.get("/", response_model=list[CategoryOut])
def get_categories(
    include_hidden: bool = False,
    db: Session = Depends(get_db)
):
    query = db.query(Category)

    if not include_hidden:
        query = query.filter(Category.is_active == True)

    categories = query.order_by(Category.sort_order.asc()).all()

    return categories


# 2. Thêm danh mục
@router.post("/", response_model=CategoryOut, status_code=201)
def create_category(
    data: CategoryCreate,
    db: Session = Depends(get_db)
):
    name = data.name.strip()

    if name == "":
        raise HTTPException(status_code=400, detail="Tên danh mục không được để trống")

    old_category = db.query(Category).filter(
        Category.name == name
    ).first()

    if old_category:
        raise HTTPException(status_code=400, detail="Tên danh mục đã tồn tại")

    category = Category(
        name=name,
        sort_order=data.sort_order,
        is_active=True
    )

    db.add(category)
    db.commit()
    db.refresh(category)

    return category


# 3. Sửa danh mục
@router.put("/{category_id}", response_model=CategoryOut)
def update_category(
    category_id: int,
    data: CategoryUpdate,
    db: Session = Depends(get_db)
):
    category = db.query(Category).filter(
        Category.id == category_id
    ).first()

    if not category:
        raise HTTPException(status_code=404, detail="Không tìm thấy danh mục")

    if data.name is not None:
        name = data.name.strip()

        if name == "":
            raise HTTPException(status_code=400, detail="Tên danh mục không được để trống")

        old_category = db.query(Category).filter(
            Category.name == name,
            Category.id != category_id
        ).first()

        if old_category:
            raise HTTPException(status_code=400, detail="Tên danh mục đã tồn tại")

        category.name = name

    if data.sort_order is not None:
        category.sort_order = data.sort_order

    db.commit()
    db.refresh(category)

    return category


# 4. Sắp xếp thứ tự danh mục
@router.patch("/reorder")
def reorder_categories(
    data: CategoryReorder,
    db: Session = Depends(get_db)
):
    category_ids = []

    for item in data.categories:
        if item.id in category_ids:
            raise HTTPException(status_code=400, detail="Danh mục bị trùng ID")

        category_ids.append(item.id)

    for item in data.categories:
        category = db.query(Category).filter(
            Category.id == item.id
        ).first()

        if not category:
            raise HTTPException(
                status_code=404,
                detail=f"Không tìm thấy danh mục ID {item.id}"
            )

        category.sort_order = item.sort_order

    db.commit()

    return {"message": "Cập nhật thứ tự danh mục thành công"}


# 5. Ẩn hoặc hiện danh mục
@router.patch("/{category_id}/status", response_model=CategoryOut)
def update_category_status(
    category_id: int,
    data: CategoryStatusUpdate,
    db: Session = Depends(get_db)
):
    category = db.query(Category).filter(
        Category.id == category_id
    ).first()

    if not category:
        raise HTTPException(status_code=404, detail="Không tìm thấy danh mục")

    category.is_active = data.is_active

    db.commit()
    db.refresh(category)

    return category


# 6. Xoá danh mục
@router.delete("/{category_id}")
def delete_category(
    category_id: int,
    db: Session = Depends(get_db)
):
    category = db.query(Category).filter(
        Category.id == category_id
    ).first()

    if not category:
        raise HTTPException(status_code=404, detail="Không tìm thấy danh mục")

    dish_count = db.query(Dish).filter(
        Dish.category_id == category_id
    ).count()

    if dish_count > 0:
        raise HTTPException(
            status_code=400,
            detail="Không thể xoá danh mục vì vẫn còn món ăn"
        )

    db.delete(category)
    db.commit()

    return {"message": "Xoá danh mục thành công"}