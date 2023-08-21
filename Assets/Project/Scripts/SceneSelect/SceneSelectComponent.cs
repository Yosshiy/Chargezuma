using System.Collections;
using System.Collections.Generic;
using UniRx;
using UnityEngine;
using Zenject;


public class SceneSelectComponent : MonoBehaviour
{
    [Inject]
    SceneAdaptor Adaptor;

    [SerializeField]
    List<StageChangeChild> ChildList;

    private void Awake()
    {
        var update = Observable.EveryUpdate()
                               .Where(x => Input.GetKeyDown(KeyCode.Return));

        foreach(var list in ChildList)
        {
            update.Select(x => list.OnStaysum)
                  .Where(x => x == true)
                  .Subscribe(x => SceneLoad(list.OnSceneName))
                  .AddTo(list);

        }    
    }

    async void SceneLoad(string name)
    {
        await Adaptor.SceneLoadAsync(name);
    }
}
