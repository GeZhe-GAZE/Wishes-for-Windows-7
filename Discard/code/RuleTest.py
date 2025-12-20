from ManageSystem import WishRuleSystem

system = WishRuleSystem(r"Data/LogicConfig")
print(system.logics)
logic = system.logics["崩坏：星穹铁道角色规则"]

counter = 0
while True:
    input()
    counter += 1
    res = logic.wish()
    print(f"{counter}. {res}")
    if res.star == 5:
        print("-" * 50)
        counter = 0
    if res.star == 4:
        print("+" * 50)
