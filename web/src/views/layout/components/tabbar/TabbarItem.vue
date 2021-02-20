<template>
  <van-tabbar-item
    v-if="
      hasOneShowingChild(item.children, item) &&
      (!onlyOneChild.children || onlyOneChild.noShowingChildren) &&
      !item.alwaysShow
    "
    :key="item.path"
    :to="item.path"
    :name="item.path"
  >
    <span>{{ onlyOneChild.meta.title }}</span>
    <template #icon="props">
      <i :class="item.meta.icon"></i>
    </template>
  </van-tabbar-item>
  <van-tabbar-item
    v-else
    :key="item.path"
    :to="{ name: 'tabbarMenu', params: { child: item.children }}"
    :icon="item.meta.icon"
  >
    <span>{{ item.meta.title }}</span>
    <template #icon="props">
      <i :class="item.meta.icon"></i>
    </template>
  </van-tabbar-item>
</template>
<script>
export default {
  props: {
    item: {
      type: Object,
      required: true,
    },
  },
  data() {
    // To fix https://github.com/PanJiaChen/vue-admin-template/issues/237
    // TODO: refactor with render function
    this.onlyOneChild = null;
    return {};
  },
  methods: {
    hasOneShowingChild(children = [], parent) {
      const showingChildren = children.filter((item) => {
        if (item.hidden) {
          return false;
        } else {
          // Temp set(will be used if only has one showing child)
          this.onlyOneChild = item;
          return true;
        }
      });

      // When there is only one child router, the child router is displayed by default
      if (showingChildren.length === 1) {
        return true;
      }

      // Show parent if there are no child router to display
      if (showingChildren.length === 0) {
        this.onlyOneChild = { ...parent, path: "", noShowingChildren: true };
        return true;
      }

      return false;
    },
    resolvePath(routePath) {
      if (isExternal(routePath)) {
        return routePath;
      }
      if (isExternal(this.basePath)) {
        return this.basePath;
      }
      return path.resolve(this.basePath, routePath);
    },
  },
};
</script>