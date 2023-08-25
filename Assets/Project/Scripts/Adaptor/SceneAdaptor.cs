using Cysharp.Threading.Tasks;
using Chargezuma.Domain.Entity;
using UniRx;

/// <summary>
/// 出力用インターフェース
/// </summary>
public interface ISceneOutput
{
    UniTask FadeIn();
    UniTask FadeOut();
}

/// <summary>
/// アダプターのインターフェース
/// Entityのみで処理が完結する場合はここから情報を取りMVRPのように扱う
/// </summary>
public interface ISceneAdaptor
{
    void LoadScene(string value);
    void Finish();
}

/// <summary>
/// Sceneのアダプタークラス
/// EntityとViewをUsecaseを介さずつなぐため、扱いに注意
/// </summary>
public class SceneAdaptor : ISceneAdaptor 
{
    ISceneEntity Entity = default;
    ISceneOutput Output = default;
    CompositeDisposable ComDispose = default;

    /// <summary>
    /// コンストラクタ
    /// 値の代入を行う
    /// </summary>
    public SceneAdaptor(ISceneEntity entity,ISceneOutput output)
    {
        Entity = entity;
        Output = output;
        ComDispose = new CompositeDisposable();
    }

    /// <summary>
    /// シーンの遷移
    /// </summary>
    public async void LoadScene(string value)
    {
        await Output.FadeIn();
        await Entity.SceneLoad(value);
        await Output.FadeOut();
    }

    /// <summary>
    /// 解放用
    /// </summary>
    void ISceneAdaptor.Finish()
    {
        ComDispose.Dispose();
    }
}
