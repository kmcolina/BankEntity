from django.urls import include, path, re_path
from rest_framework.routers import SimpleRouter

from apikaran.authentication.views import AuthViewSet, AuthLogin

router = SimpleRouter()
router.register('', AuthViewSet, basename='auth')

urlpatterns = [
    path('', include(router.urls)),
    re_path(r"^login/$", AuthLogin.as_view(), name="login"),
]
