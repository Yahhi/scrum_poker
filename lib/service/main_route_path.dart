/// Class is having all parameters decoded from path
class MainRoutePath {
  MainRoutePath(this.pages);

  factory MainRoutePath.onboarding() => MainRoutePath([const PageData(PageType.projectList), const PageData(PageType.onboarding)]);
  factory MainRoutePath.settings() => MainRoutePath([const PageData(PageType.projectList), const PageData(PageType.settings)]);
  factory MainRoutePath.splash() => MainRoutePath([const PageData(PageType.splash)]);
  factory MainRoutePath.unknown() => MainRoutePath([const PageData(PageType.projectList), const PageData(PageType.page404)]);

  factory MainRoutePath.projectsList() => MainRoutePath([const PageData(PageType.projectList)]);
  factory MainRoutePath.projectEdit(String id) => MainRoutePath([const PageData(PageType.projectList), PageData(PageType.projectEdit, param: id)]);
  factory MainRoutePath.projectAdd() => MainRoutePath([const PageData(PageType.projectList), const PageData(PageType.projectEdit)]);

  factory MainRoutePath.taskList(String projectId) => MainRoutePath([const PageData(PageType.projectList), PageData(PageType.taskList, param: projectId)]);
  factory MainRoutePath.taskAdd(String projectId) =>
      MainRoutePath([const PageData(PageType.projectList), PageData(PageType.taskList, param: projectId), const PageData(PageType.taskEdit)]);
  factory MainRoutePath.taskEdit(String projectId, String taskId) =>
      MainRoutePath([const PageData(PageType.projectList), PageData(PageType.taskList, param: projectId), PageData(PageType.taskEdit, param: taskId)]);
  factory MainRoutePath.taskDetails(String projectId, String taskId) =>
      MainRoutePath([const PageData(PageType.projectList), PageData(PageType.taskList, param: projectId), PageData(PageType.taskStats, param: taskId)]);
  factory MainRoutePath.taskVote(String projectId, String taskId) => MainRoutePath([
        const PageData(PageType.projectList),
        PageData(PageType.taskList, param: projectId),
        PageData(PageType.taskStats, param: taskId),
        const PageData(PageType.taskVote)
      ]);

  factory MainRoutePath.personList() => MainRoutePath([const PageData(PageType.projectList), const PageData(PageType.peopleList)]);
  factory MainRoutePath.personAdd() =>
      MainRoutePath([const PageData(PageType.projectList), const PageData(PageType.peopleList), const PageData(PageType.peopleEdit)]);
  factory MainRoutePath.personEdit(String personId) =>
      MainRoutePath([const PageData(PageType.projectList), const PageData(PageType.peopleList), PageData(PageType.peopleEdit, param: personId)]);
  factory MainRoutePath.personDetails(String personId) =>
      MainRoutePath([const PageData(PageType.projectList), const PageData(PageType.peopleList), PageData(PageType.peopleDetails, param: personId)]);

  final List<PageData> pages;

  @override
  String toString() {
    final StringBuffer result = StringBuffer();
    for (var page in pages) {
      result.writeln('${page.pageType} - ${page.param ?? 'no param'}');
    }
    return result.toString();
  }

  MainRoutePath removeLastPart() {
    if (pages.length == 1) {
      return this;
    } else {
      return MainRoutePath(pages.sublist(0, pages.length - 1));
    }
  }
}

enum PageType {
  projectList,
  projectEdit,
  taskList,
  taskEdit,
  taskVote,
  taskStats,
  peopleList,
  peopleEdit,
  peopleDetails,
  settings,
  splash,
  page404,
  onboarding
}

extension PageTypePathWords on PageType {
  String get pathWord => PageData.paths[this] ?? '';
}

class PageData {
  const PageData(this.pageType, {this.param});

  final PageType pageType;
  final String? param;

  static const paths = {
    PageType.projectList: 'projects',
    PageType.projectEdit: 'edit',
    PageType.taskEdit: 'edit',
    PageType.peopleEdit: 'edit',
    PageType.taskList: 'tasks',
    PageType.taskVote: 'vote',
    PageType.taskStats: 'stats',
    PageType.peopleList: 'people',
    PageType.peopleDetails: 'details',
    PageType.settings: 'settings',
    PageType.splash: '',
    PageType.page404: '404',
    PageType.onboarding: 'onboarding'
  };

  static PageType? findType(String pathPart) {
    for (var mapEntry in paths.entries) {
      if (mapEntry.value == pathPart) {
        return mapEntry.key;
      }
    }
    return null;
  }

  static bool canHaveParam(PageType pageType) =>
      pageType == PageType.projectEdit ||
      pageType == PageType.taskEdit ||
      pageType == PageType.peopleEdit ||
      pageType == PageType.taskStats ||
      pageType == PageType.peopleDetails ||
      pageType == PageType.taskList;
}
