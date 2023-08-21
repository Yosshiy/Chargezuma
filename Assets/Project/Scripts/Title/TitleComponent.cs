using UniRx;
using UnityEngine;
using Zenject;

/// <summary>
/// タイトル画面専用のスクリプト
/// </summary>
public class TitleComponent : MonoBehaviour
{
    [Inject]
    SceneAdaptor Adaptor;

    /// <summary>
    /// シーン移動の条件を定義
    /// </summary>
    private void Awake()
    {
        Observable.EveryUpdate()
                  .Where(x => Input.GetKeyDown(KeyCode.Return))
                  .Subscribe(x => SceneLoad())
                  .AddTo(this);
    }

    /// <summary>
    /// StageSelectシーンに遷移
    /// </summary>
    async void SceneLoad()
    {
        await Adaptor.SceneLoadAsync("StageSelect");
    } 
}
