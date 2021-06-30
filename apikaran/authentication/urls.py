from django.urls import include, path
from rest_framework.routers import DefaultRouter

from apikaran.authentication.views import AuthViewSet

router = DefaultRouter()
router.register('auth', AuthViewSet, basename='auth')

urlpatterns = [
    path('', include(router.urls))
]