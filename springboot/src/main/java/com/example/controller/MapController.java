package com.example.controller;

import com.example.common.Result;
import org.springframework.web.bind.annotation.*;

import java.util.*;

/**
 * 扶贫地图相关API控制器
 */
@RestController
@RequestMapping("/map")
public class MapController {

    /**
     * 获取扶贫项目地理分布数据
     */
    @GetMapping("/regions")
    public Result getRegionsData(@RequestParam(defaultValue = "all") String year,
                                @RequestParam(defaultValue = "all") String category,
                                @RequestParam(defaultValue = "") String search) {
        
        List<Map<String, Object>> regions = new ArrayList<>();
        
        // 山西省数据
        Map<String, Object> shanxi = new HashMap<>();
        shanxi.put("name", "山西省");
        shanxi.put("code", "SX");
        shanxi.put("projects", 45);
        shanxi.put("beneficiaries", 13500);
        shanxi.put("investment", 8500);
        shanxi.put("category", "key");
        shanxi.put("coord", Arrays.asList(112.53, 37.87));
        
        List<Map<String, Object>> shanxiProjects = new ArrayList<>();
        shanxiProjects.add(createProject(1, "晋中果品产业扶贫", "农业扶贫", "2024-01", 1200, "in_progress", 85, 450, "晋中市"));
        shanxiProjects.add(createProject(2, "阳泉教育基础设施", "教育扶贫", "2023-08", 800, "completed", 100, 380, "阳泉市"));
        shanxiProjects.add(createProject(3, "临汾医疗服务提升", "医疗扶贫", "2023-12", 650, "in_progress", 67, 290, "临汾市"));
        shanxi.put("projectList", shanxiProjects);
        regions.add(shanxi);
        
        // 云南省数据
        Map<String, Object> yunnan = new HashMap<>();
        yunnan.put("name", "云南省");
        yunnan.put("code", "YN");
        yunnan.put("projects", 38);
        yunnan.put("beneficiaries", 11400);
        yunnan.put("investment", 7200);
        yunnan.put("category", "key");
        yunnan.put("coord", Arrays.asList(102.73, 25.04));
        
        List<Map<String, Object>> yunnanProjects = new ArrayList<>();
        yunnanProjects.add(createProject(4, "普洱茶产业扶贫", "农业扶贫", "2024-02", 1500, "in_progress", 72, 520, "普洱市"));
        yunnanProjects.add(createProject(5, "怒江交通建设", "基础设施", "2023-10", 2000, "in_progress", 45, 680, "怒江州"));
        yunnanProjects.add(createProject(6, "大理旅游扶贫", "文旅扶贫", "2023-09", 900, "completed", 100, 350, "大理州"));
        yunnan.put("projectList", yunnanProjects);
        regions.add(yunnan);
        
        // 贵州省数据
        Map<String, Object> guizhou = new HashMap<>();
        guizhou.put("name", "贵州省");
        guizhou.put("code", "GZ");
        guizhou.put("projects", 42);
        guizhou.put("beneficiaries", 12600);
        guizhou.put("investment", 9100);
        guizhou.put("category", "key");
        guizhou.put("coord", Arrays.asList(106.71, 26.57));
        
        List<Map<String, Object>> guizhouProjects = new ArrayList<>();
        guizhouProjects.add(createProject(7, "遵义辣椒产业", "农业扶贫", "2024-01", 1100, "in_progress", 78, 420, "遵义市"));
        guizhouProjects.add(createProject(8, "毕节职业培训", "教育扶贫", "2023-11", 600, "in_progress", 89, 310, "毕节市"));
        guizhouProjects.add(createProject(9, "黔南生态修复", "环保扶贫", "2023-07", 1300, "completed", 100, 560, "黔南州"));
        guizhou.put("projectList", guizhouProjects);
        regions.add(guizhou);
        
        // 甘肃省数据
        Map<String, Object> gansu = new HashMap<>();
        gansu.put("name", "甘肃省");
        gansu.put("code", "GS");
        gansu.put("projects", 35);
        gansu.put("beneficiaries", 10500);
        gansu.put("investment", 6800);
        gansu.put("category", "key");
        gansu.put("coord", Arrays.asList(103.73, 36.03));
        
        List<Map<String, Object>> gansuProjects = new ArrayList<>();
        gansuProjects.add(createProject(10, "陇南中药材种植", "农业扶贫", "2024-02", 980, "in_progress", 65, 380, "陇南市"));
        gansuProjects.add(createProject(11, "临夏畜牧业发展", "农业扶贫", "2023-09", 750, "in_progress", 82, 290, "临夏州"));
        gansu.put("projectList", gansuProjects);
        regions.add(gansu);
        
        // 新疆数据
        Map<String, Object> xinjiang = new HashMap<>();
        xinjiang.put("name", "新疆");
        xinjiang.put("code", "XJ");
        xinjiang.put("projects", 32);
        xinjiang.put("beneficiaries", 9600);
        xinjiang.put("investment", 5900);
        xinjiang.put("category", "key");
        xinjiang.put("coord", Arrays.asList(87.68, 43.77));
        
        List<Map<String, Object>> xinjiangProjects = new ArrayList<>();
        xinjiangProjects.add(createProject(12, "南疆棉花产业", "农业扶贫", "2024-01", 1200, "in_progress", 70, 450, "南疆地区"));
        xinjiangProjects.add(createProject(13, "喀什职业技能培训", "教育扶贫", "2023-10", 680, "in_progress", 75, 320, "喀什地区"));
        xinjiang.put("projectList", xinjiangProjects);
        regions.add(xinjiang);
        
        // 应用筛选条件
        List<Map<String, Object>> filteredRegions = applyFilters(regions, year, category, search);
        
        return Result.success(filteredRegions);
    }
    
    /**
     * 获取扶贫统计概览数据
     */
    @GetMapping("/statistics")
    public Result getStatistics() {
        Map<String, Object> statistics = new HashMap<>();
        statistics.put("totalProjects", 485);
        statistics.put("provinces", 31);
        statistics.put("totalBeneficiaries", 156.8);
        statistics.put("totalInvestment", 425.6);
        
        Map<String, Object> dailyGrowth = new HashMap<>();
        dailyGrowth.put("projects", (int)(Math.random() * 10) + 3);
        dailyGrowth.put("beneficiaries", (int)(Math.random() * 500) + 600);
        statistics.put("dailyGrowth", dailyGrowth);
        
        statistics.put("onlineUsers", 1200 + (int)(Math.random() * 600));
        
        return Result.success(statistics);
    }
    
    /**
     * 获取项目类型分布数据
     */
    @GetMapping("/categories")
    public Result getProjectCategories() {
        List<Map<String, Object>> categories = new ArrayList<>();
        
        Map<String, Object> agriculture = new HashMap<>();
        agriculture.put("name", "农业扶贫");
        agriculture.put("count", 186);
        agriculture.put("color", "bg-green-500");
        agriculture.put("type", "agriculture");
        agriculture.put("percentage", 38);
        categories.add(agriculture);
        
        Map<String, Object> education = new HashMap<>();
        education.put("name", "教育扶贫");
        education.put("count", 124);
        education.put("color", "bg-blue-500");
        education.put("type", "education");
        education.put("percentage", 26);
        categories.add(education);
        
        Map<String, Object> healthcare = new HashMap<>();
        healthcare.put("name", "医疗扶贫");
        healthcare.put("count", 89);
        healthcare.put("color", "bg-red-500");
        healthcare.put("type", "healthcare");
        healthcare.put("percentage", 18);
        categories.add(healthcare);
        
        Map<String, Object> infrastructure = new HashMap<>();
        infrastructure.put("name", "基础设施");
        infrastructure.put("count", 86);
        infrastructure.put("color", "bg-yellow-500");
        infrastructure.put("type", "infrastructure");
        infrastructure.put("percentage", 18);
        categories.add(infrastructure);
        
        return Result.success(categories);
    }
    
    /**
     * 获取热门地区排行
     */
    @GetMapping("/hot-regions")
    public Result getHotRegions() {
        List<Map<String, Object>> hotRegions = new ArrayList<>();
        
        Map<String, Object> shanxi = new HashMap<>();
        shanxi.put("name", "山西省");
        shanxi.put("projects", 45);
        shanxi.put("code", "SX");
        shanxi.put("category", "key");
        hotRegions.add(shanxi);
        
        Map<String, Object> guizhou = new HashMap<>();
        guizhou.put("name", "贵州省");
        guizhou.put("projects", 42);
        guizhou.put("code", "GZ");
        guizhou.put("category", "key");
        hotRegions.add(guizhou);
        
        Map<String, Object> yunnan = new HashMap<>();
        yunnan.put("name", "云南省");
        yunnan.put("projects", 38);
        yunnan.put("code", "YN");
        yunnan.put("category", "key");
        hotRegions.add(yunnan);
        
        Map<String, Object> gansu = new HashMap<>();
        gansu.put("name", "甘肃省");
        gansu.put("projects", 35);
        gansu.put("code", "GS");
        gansu.put("category", "key");
        hotRegions.add(gansu);
        
        Map<String, Object> xinjiang = new HashMap<>();
        xinjiang.put("name", "新疆");
        xinjiang.put("projects", 32);
        xinjiang.put("code", "XJ");
        xinjiang.put("category", "key");
        hotRegions.add(xinjiang);
        
        return Result.success(hotRegions);
    }
    
    /**
     * 获取最新项目动态
     */
    @GetMapping("/recent-projects")
    public Result getRecentProjects() {
        List<Map<String, Object>> recentProjects = new ArrayList<>();
        
        Map<String, Object> project1 = new HashMap<>();
        project1.put("id", 1);
        project1.put("name", "晋中果品产业扶贫");
        project1.put("location", "山西晋中");
        project1.put("date", "2024-01-15");
        project1.put("investment", 1200);
        project1.put("isNew", true);
        recentProjects.add(project1);
        
        Map<String, Object> project2 = new HashMap<>();
        project2.put("id", 2);
        project2.put("name", "普洱茶产业扶贫");
        project2.put("location", "云南普洱");
        project2.put("date", "2024-02-08");
        project2.put("investment", 1500);
        project2.put("isNew", true);
        recentProjects.add(project2);
        
        Map<String, Object> project3 = new HashMap<>();
        project3.put("id", 3);
        project3.put("name", "遵义辣椒产业");
        project3.put("location", "贵州遵义");
        project3.put("date", "2024-01-20");
        project3.put("investment", 1100);
        project3.put("isNew", false);
        recentProjects.add(project3);
        
        Map<String, Object> project4 = new HashMap<>();
        project4.put("id", 4);
        project4.put("name", "陇南中药材种植");
        project4.put("location", "甘肃陇南");
        project4.put("date", "2024-02-12");
        project4.put("investment", 980);
        project4.put("isNew", true);
        recentProjects.add(project4);
        
        return Result.success(recentProjects);
    }
    
    /**
     * 高级筛选API
     */
    @PostMapping("/filter")
    public Result filterRegions(@RequestBody Map<String, Object> filters) {
        // 获取基础数据
        Result regionsResult = getRegionsData("all", "all", "");
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> regions = (List<Map<String, Object>>) regionsResult.getData();
        
        // 应用高级筛选
        List<Map<String, Object>> filteredRegions = applyAdvancedFilters(regions, filters);
        
        return Result.success(filteredRegions);
    }
    
    /**
     * 创建项目对象
     */
    private Map<String, Object> createProject(int id, String name, String category, String startDate, 
                                            int investment, String status, int progress, int beneficiaries, String location) {
        Map<String, Object> project = new HashMap<>();
        project.put("id", id);
        project.put("name", name);
        project.put("category", category);
        project.put("startDate", startDate);
        project.put("investment", investment);
        project.put("status", status);
        project.put("progress", progress);
        project.put("beneficiaries", beneficiaries);
        project.put("location", location);
        return project;
    }
    
    /**
     * 应用基础筛选条件
     */
    private List<Map<String, Object>> applyFilters(List<Map<String, Object>> regions, String year, String category, String search) {
        return regions.stream()
            .filter(region -> {
                // 搜索筛选
                if (!search.isEmpty()) {
                    String name = (String) region.get("name");
                    return name.toLowerCase().contains(search.toLowerCase());
                }
                return true;
            })
            .filter(region -> {
                // 项目类型筛选
                if (!"all".equals(category)) {
                    @SuppressWarnings("unchecked")
                    List<Map<String, Object>> projectList = (List<Map<String, Object>>) region.get("projectList");
                    if (projectList != null) {
                        return projectList.stream().anyMatch(project -> {
                            String projectCategory = (String) project.get("category");
                            return categoryMatches(projectCategory, category);
                        });
                    }
                }
                return true;
            })
            .collect(java.util.stream.Collectors.toList());
    }
    
    /**
     * 应用高级筛选条件
     */
    private List<Map<String, Object>> applyAdvancedFilters(List<Map<String, Object>> regions, Map<String, Object> filters) {
        return regions.stream()
            .filter(region -> {
                // 项目数量范围筛选
                if (filters.containsKey("projectMin") && !filters.get("projectMin").toString().isEmpty()) {
                    int projectMin = Integer.parseInt(filters.get("projectMin").toString());
                    int projects = (Integer) region.get("projects");
                    if (projects < projectMin) return false;
                }
                if (filters.containsKey("projectMax") && !filters.get("projectMax").toString().isEmpty()) {
                    int projectMax = Integer.parseInt(filters.get("projectMax").toString());
                    int projects = (Integer) region.get("projects");
                    if (projects > projectMax) return false;
                }
                
                // 受益人数范围筛选
                if (filters.containsKey("beneficiariesMin") && !filters.get("beneficiariesMin").toString().isEmpty()) {
                    int beneficiariesMin = Integer.parseInt(filters.get("beneficiariesMin").toString());
                    int beneficiaries = (Integer) region.get("beneficiaries");
                    if (beneficiaries < beneficiariesMin) return false;
                }
                if (filters.containsKey("beneficiariesMax") && !filters.get("beneficiariesMax").toString().isEmpty()) {
                    int beneficiariesMax = Integer.parseInt(filters.get("beneficiariesMax").toString());
                    int beneficiaries = (Integer) region.get("beneficiaries");
                    if (beneficiaries > beneficiariesMax) return false;
                }
                
                // 地区类型筛选
                if (filters.containsKey("regionType") && !"all".equals(filters.get("regionType"))) {
                    String regionType = filters.get("regionType").toString();
                    String category = (String) region.get("category");
                    if (!regionType.equals(category)) return false;
                }
                
                return true;
            })
            .collect(java.util.stream.Collectors.toList());
    }
    
    /**
     * 检查项目类型是否匹配
     */
    private boolean categoryMatches(String projectCategory, String filterCategory) {
        Map<String, String> categoryMap = new HashMap<>();
        categoryMap.put("agriculture", "农业扶贫");
        categoryMap.put("education", "教育扶贫");
        categoryMap.put("healthcare", "医疗扶贫");
        categoryMap.put("infrastructure", "基础设施");
        categoryMap.put("tourism", "文旅扶贫");
        
        return projectCategory.equals(categoryMap.get(filterCategory));
    }
}
