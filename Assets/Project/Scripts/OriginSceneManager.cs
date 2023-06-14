using Cysharp.Threading.Tasks;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using UnityEngine;
using UnityEngine.SceneManagement;

public class OriginSceneManager : MonoBehaviour
{
    public static OriginSceneManager instance;
    [SerializeField] Fade FadeAnim;
    [SerializeField] LoadingAnim LoadAnim;

    private void Awake()
    {
        if (instance == null)
        {
            instance = this;
        }
        else
        {
            Destroy(gameObject);
        }

        OnInitialize();
    }


    void OnInitialize()
    {
        SceneManager.LoadScene("Title",LoadSceneMode.Additive);
    }

    public async void LoadScene(string oldscene,string scenename,bool isload = false)
    {
        await FadeAnim.FadeIn();

        await SceneManager.UnloadSceneAsync(oldscene);

        SceneManager.LoadScene(scenename, LoadSceneMode.Additive);

        if (isload)
        {
            LoadAnim.OnInitialized();
        }

        FadeAnim.FadeOut();

        await UniTask.Delay(10000);

        await FadeAnim.FadeIn();

        FadeAnim.FadeOut();

        if (isload)
        {
            LoadAnim.EndAnimation();
        }

    }

}