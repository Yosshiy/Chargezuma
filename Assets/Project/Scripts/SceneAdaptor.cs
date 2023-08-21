using Cysharp.Threading.Tasks;
using DG.Tweening;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

/// <summary>
/// Scene関連のスクリプト
/// シーン遷移時のアニメーション、処理等を記載
/// </summary>
public class SceneAdaptor : MonoBehaviour
{
    [SerializeField] Image FadePanel;
    const string MASTERNAME = "Main";

    void Awake()
    {
        SceneManager.LoadSceneAsync("Title", LoadSceneMode.Additive);
    }

    /// <summary>
    /// フェードインアニメーション
    /// 合計アニメーション時間 : 1.5f
    /// </summary>
    public async UniTask FadeIn()
    {
        await DOTween.Sequence()
               .Append(FadePanel.material.DOFloat(0.5f, "_Fade", 0.3f).SetEase(Ease.OutBack))
               .AppendInterval(0.2f)
               .Append(FadePanel.material.DOFloat(1.5f, "_Fade", 0.5f).SetEase(Ease.OutCirc))
               .Append(FadePanel.material.DOFloat(1.2f, "_Volt", 0.5f))
               .SetLink(this.gameObject);
    }

    /// <summary>
    /// フェードアウトのアニメーション
    /// 合計アニメーション時間 : 1.5f
    /// </summary>
    public async UniTask FadeOut()
    {
        await DOTween.Sequence()
               .AppendInterval(1)
               .Append(FadePanel.material.DOFloat(0f, "_Volt", 0.5f))
               .Append(FadePanel.material.DOFloat(0f, "_Fade", 0.5f).SetEase(Ease.OutCirc))
               .SetLink(this.gameObject);
    }

    public async UniTask ReLoad(string name)
    {
        Scene oldscene = SceneManager.GetSceneByName(name);

        await FadeIn();
        await SceneManager.UnloadSceneAsync(oldscene);
        await SceneManager.LoadSceneAsync(name, LoadSceneMode.Additive);
        await FadeOut();

    }

    public async UniTask SceneLoadAsync(string name)
    {
        List<Scene> old = new List<Scene>();

        for(int i = 0;i < SceneManager.sceneCount; i++)
        {
            old.Add(SceneManager.GetSceneAt(i));
        }

        var oldA = old.Where(x => x.name != MASTERNAME).First();

        await FadeIn();
        await SceneManager.LoadSceneAsync(name, LoadSceneMode.Additive);
        await SceneManager.UnloadSceneAsync(oldA);
        await FadeOut();

    }

    


}
